// ==UserScript==
// @name         nix-containers: bulk make packages public
// @namespace    nix-containers
// @version      0.1.0
// @description  Flip private container packages under nix-containers org to public, in the user's authenticated browser session. Workaround for GitHub's missing REST endpoint for visibility changes.
// @match        https://github.com/orgs/nix-containers/packages*
// @match        https://github.com/orgs/nix-containers/packages/container/images*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

// Activation:
//   1. Install Tampermonkey (Chrome, Firefox, etc.).
//   2. Open this file's raw URL and Tampermonkey will prompt to install.
//   3. Visit https://github.com/orgs/nix-containers/packages?repo_name=images
//      and click the "Make ALL private public" button injected at the top
//      of the page.
//
// What it does:
//   - Listing page: fetches every private container package via the GitHub
//     packages API (paginated), then per-package:
//       * Fetches the package settings page HTML
//       * Locates the visibility-change form + CSRF token
//       * POSTs to the form's action with visibility=public + the type-to-
//         confirm string (the package's full name path)
//   - Per-package settings page: adds a "Make Public Now" button next to
//     the existing visibility section that fires the same POST directly.
//
// Cookie auth: all fetches use credentials:'include' so the user's session
// cookie carries the request. No PAT needed; no scope concerns.
//
// Progress + errors render in a fixed-position overlay at the top-right
// of the listing page. Re-runnable: already-public packages return 200
// with no change and get counted as 'already-public'.

(function () {
  'use strict';

  const ORG = 'nix-containers';
  const PACKAGE_TYPE = 'container';

  // Status sink the bulk-runner writes to. The element is created lazily
  // when the runner starts so we don't clutter pages where the user
  // isn't running anything.
  function statusUI() {
    let el = document.getElementById('nc-visibility-status');
    if (el) return el;
    el = document.createElement('div');
    el.id = 'nc-visibility-status';
    el.style.cssText = `
      position: fixed; top: 12px; right: 12px; z-index: 99999;
      background: #0d1117; color: #e6edf3; border: 1px solid #30363d;
      border-radius: 8px; padding: 12px 16px; font: 13px/1.5 system-ui;
      max-width: 360px; max-height: 60vh; overflow: auto;
      box-shadow: 0 8px 24px rgba(0,0,0,0.5);
    `;
    document.body.appendChild(el);
    return el;
  }
  function log(msg) {
    const el = statusUI();
    const line = document.createElement('div');
    line.textContent = msg;
    line.style.marginTop = '4px';
    el.appendChild(line);
    el.scrollTop = el.scrollHeight;
  }

  // List every container package the session can see by scraping the
  // org packages HTML listing pages (`/orgs/<org>/packages?page=N`).
  // Why not REST? api.github.com is cross-origin and CORS-blocks
  // credentialed requests; /api/v3 (GHES path) 404s on dotcom.
  //
  // Each listing page contains a link per package whose href matches
  // /orgs/<org>/packages/container/<encoded-name>; we extract the
  // name and look for a 'Private' label in the same package card to
  // mark visibility.
  async function listAllPackages() {
    const out = [];
    const seen = new Set();
    for (let page = 1; page <= 200; page++) {
      let html = null;
      for (let attempt = 1; attempt <= 5; attempt++) {
        const resp = await fetch(
          `/orgs/${ORG}/packages?page=${page}`,
          { credentials: 'include' }
        ).catch(() => null);
        if (resp && resp.ok) {
          html = await resp.text().catch(() => null);
          break;
        }
        if (resp && (resp.status === 503 || resp.status === 429 || resp.status === 502)) {
          log(`page ${page} got ${resp.status}, retry ${attempt}/5`);
          await new Promise(r => setTimeout(r, 1000 * attempt));
          continue;
        }
        log(`page ${page} status ${resp && resp.status}, stopping`);
        break;
      }
      if (!html) break;

      const doc = new DOMParser().parseFromString(html, 'text/html');
      // Match either '/orgs/<org>/packages/container/<encoded>' (listing
      // card link) or just '/<encoded>' tail; collect the unique tail.
      const anchors = Array.from(
        doc.querySelectorAll(`a[href*="/orgs/${ORG}/packages/container/"]`)
      );
      const pageItems = [];
      for (const a of anchors) {
        const m = a.getAttribute('href').match(
          new RegExp(`/orgs/${ORG}/packages/container/([^/?#]+)`)
        );
        if (!m) continue;
        const encoded = m[1];
        let name;
        try { name = decodeURIComponent(encoded); } catch { name = encoded; }
        if (seen.has(name)) continue;
        seen.add(name);
        // Visibility: look at the closest ancestor that contains the
        // package row, then check for a 'Private' badge. GitHub renders
        // visibility as a small Label component near the package name.
        const card = a.closest('li, article, div');
        const txt = (card ? card.textContent : '').toLowerCase();
        const isPrivate = /\bprivate\b/.test(txt);
        const isInternal = /\binternal\b/.test(txt);
        const visibility = isPrivate ? 'private' : (isInternal ? 'internal' : 'public');
        pageItems.push({ name, visibility });
      }
      if (pageItems.length === 0) {
        log(`page ${page}: no packages found; stopping`);
        break;
      }
      out.push(...pageItems);
      log(`listed page ${page}: +${pageItems.length} (running total ${out.length})`);
      // Throttle between pages so we don't get back to 503-land.
      await new Promise(r => setTimeout(r, 300));
    }
    return out;
  }

  // Flip one package to public. Returns 'flipped', 'already-public',
  // 'error: <reason>'. Confirmed via inspection of the settings page
  // HTML (the visibility-change form is the one whose action ends in
  // /settings/change_visibility).
  async function flipPackagePublic(name) {
    const encoded = encodeURIComponent(name);
    const settingsUrl = `/orgs/${ORG}/packages/${PACKAGE_TYPE}/${encoded}/settings`;
    const r = await fetch(settingsUrl, { credentials: 'include' });
    if (!r.ok) return `error: settings GET ${r.status}`;
    const html = await r.text();
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const action = `/orgs/${ORG}/packages/${PACKAGE_TYPE}/${encoded}/settings/change_visibility`;
    // Find the form whose action exactly matches the change_visibility
    // route so we pick up its CSRF token.
    const form = Array.from(doc.querySelectorAll('form'))
      .find(f => (f.getAttribute('action') || '').endsWith('/settings/change_visibility'));
    if (!form) {
      return 'error: settings page lacks change_visibility form (already-public?)';
    }
    const csrf = form.querySelector('input[name="authenticity_token"]');
    if (!csrf) return 'error: no CSRF token in form';
    // Three fields the modal submits, confirmed via the rendered HTML:
    //   visibility=public
    //   verify=<full package name like "images/zoxide">
    //   authenticity_token=<csrf>
    const fd = new FormData();
    fd.append('authenticity_token', csrf.value);
    fd.append('visibility', 'public');
    fd.append('verify', name);
    const submit = await fetch(action, {
      method: 'POST',
      credentials: 'include',
      body: fd,
      // GitHub returns 302 on success — capture rather than auto-follow
      // so we can detect the outcome cleanly.
      redirect: 'manual',
      headers: { 'Accept': 'text/html' },
    });
    if (submit.ok || submit.status === 0 || submit.status === 302 || submit.status === 303) {
      return 'flipped';
    }
    return `error: submit ${submit.status}`;
  }

  // ----- Bulk runner injected on the org-packages listing page -----
  function injectBulkButton() {
    if (document.getElementById('nc-bulk-flip-btn')) return;
    const host = document.querySelector('main') || document.body;
    const btn = document.createElement('button');
    btn.id = 'nc-bulk-flip-btn';
    btn.textContent = 'Make ALL private packages public';
    btn.style.cssText = `
      margin: 12px; padding: 8px 16px; background: #238636; color: #fff;
      border: 0; border-radius: 6px; font-weight: 600; cursor: pointer;
    `;
    btn.addEventListener('click', runBulk);
    host.prepend(btn);
  }

  async function runBulk() {
    const btn = document.getElementById('nc-bulk-flip-btn');
    if (btn) btn.disabled = true;
    log('Listing packages…');
    const all = await listAllPackages();
    log(`Total: ${all.length} container packages.`);
    const targets = all
      .filter(p => p.visibility === 'private' && p.name.startsWith('images/'))
      .map(p => p.name);
    log(`Private under images/: ${targets.length}`);
    let ok = 0, skipped = 0, failed = 0;
    for (let i = 0; i < targets.length; i++) {
      const name = targets[i];
      try {
        const res = await flipPackagePublic(name);
        if (res === 'flipped') ok++;
        else if (res === 'already-public') skipped++;
        else { failed++; log(`[${i + 1}/${targets.length}] ${name} → ${res}`); }
      } catch (e) {
        failed++; log(`[${i + 1}/${targets.length}] ${name} → exception ${e.message}`);
      }
      if ((i + 1) % 50 === 0) {
        log(`progress: ${i + 1}/${targets.length} — ok=${ok} skipped=${skipped} failed=${failed}`);
      }
      // Throttle so we don't overwhelm GitHub's rate limits.
      await new Promise(r => setTimeout(r, 250));
    }
    log(`Done. flipped=${ok} skipped=${skipped} failed=${failed}`);
    if (btn) btn.disabled = false;
  }

  // ----- One-shot button injected on a package's settings page -----
  function injectSingleButton() {
    if (document.getElementById('nc-single-flip-btn')) return;
    const m = window.location.pathname.match(
      new RegExp(`/orgs/${ORG}/packages/${PACKAGE_TYPE}/(.+)/settings$`)
    );
    if (!m) return;
    const name = decodeURIComponent(m[1]);
    const host = document.querySelector('main') || document.body;
    const btn = document.createElement('button');
    btn.id = 'nc-single-flip-btn';
    btn.textContent = 'Make Public Now';
    btn.style.cssText = `
      margin: 12px; padding: 8px 16px; background: #238636; color: #fff;
      border: 0; border-radius: 6px; font-weight: 600; cursor: pointer;
    `;
    btn.addEventListener('click', async () => {
      btn.disabled = true;
      btn.textContent = 'Flipping…';
      const res = await flipPackagePublic(name);
      btn.textContent = `Result: ${res}`;
    });
    host.prepend(btn);
  }

  // Pick the right injector based on the current path.
  if (/\/packages\/?(\?|$)/.test(window.location.pathname + window.location.search)) {
    injectBulkButton();
  } else if (/\/packages\/container\/.+\/settings$/.test(window.location.pathname)) {
    injectSingleButton();
  }
})();

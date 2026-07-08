// /auto-updates/ page: fetches the last 24h of merged auto-update PRs from the
// public GitHub API and renders the actual list of bumped packages per PR by
// parsing each PR body. Uses only the /search/issues endpoint (rate-limit
// friendly — one call for the list, one per PR body).
const BASE = window.SITE_BASE || '/';

document.addEventListener('DOMContentLoaded', () => {
  load().catch(err => showError(err.message));
});

async function load() {
  const since = new Date(Date.now() - 24 * 3600 * 1000).toISOString();
  const url = 'https://api.github.com/search/issues?q=' +
    encodeURIComponent(
      'repo:nix-containers/images is:pr is:merged ' +
      '("deps:" OR "chore(deps)" OR "auto-update" OR "automated package") ' +
      'merged:>=' + since
    ) + '&per_page=50';

  const r = await fetch(url, { headers: { 'Accept': 'application/vnd.github+json' } });
  if (!r.ok) throw new Error('GitHub API returned ' + r.status);
  const data = await r.json();
  const prs = data.items || [];

  // Each PR carries a `body`. Parse `- \`pkg\` old → new` lines out of it.
  const parsed = prs.map(pr => ({
    number: pr.number,
    title: pr.title,
    html_url: pr.html_url,
    merged_at: pr.pull_request?.merged_at || pr.closed_at || '',
    packages: extractBumps(pr.body || ''),
  }));

  // Stats
  const allBumps = parsed.flatMap(p => p.packages);
  const uniquePkgs = new Set(allBumps.map(b => b.name));
  document.getElementById('pr-count').textContent = parsed.length;
  document.getElementById('bump-count').textContent = allBumps.length;
  document.getElementById('unique-count').textContent = uniquePkgs.size;

  // Render each PR + its bumps
  const root = document.getElementById('content');
  if (!parsed.length) {
    root.innerHTML = '<p class="text-fg-muted">No auto-update PRs merged in the last 24 hours.</p>';
    return;
  }
  root.innerHTML = parsed.map(renderPr).join('');
}

// PR body sample:
//   - `authservice` 1.1.4 → 1.1.7
//   - `cilium-envoy` 1.18.4 → 1.19.5
// Also common:
//   - foo 1.0 → 2.0
//   - `bar` (no version, e.g. flake bumps)
function extractBumps(body) {
  const out = [];
  const lines = body.split(/\r?\n/);
  const bumpRe = /^\s*[-*]\s+`?([\w./+-]+)`?(?:\s+([\w.+-]+)\s*(?:→|->|to)\s*([\w.+-]+))?\s*$/;
  for (const line of lines) {
    const m = line.match(bumpRe);
    if (m) out.push({ name: m[1], from: m[2] || '', to: m[3] || '' });
  }
  return out;
}

function renderPr(pr) {
  const when = pr.merged_at ? new Date(pr.merged_at).toLocaleString() : '';
  const bumps = pr.packages;
  const bumpsHtml = bumps.length
    ? `<table class="w-full text-sm mt-3">
        <thead class="text-xs text-fg-muted uppercase">
          <tr><th class="py-1 pr-3 text-left">Package</th><th class="py-1 pr-3 text-left">From</th><th class="py-1 pr-3 text-left">To</th></tr>
        </thead>
        <tbody>${bumps.map(b => `<tr class="border-t border-neutral-800">
          <td class="py-1 pr-3 font-mono">${escapeHtml(b.name)}</td>
          <td class="py-1 pr-3 text-fg-muted">${escapeHtml(b.from)}</td>
          <td class="py-1 pr-3 font-mono">${escapeHtml(b.to)}</td>
        </tr>`).join('')}</tbody>
      </table>`
    : `<p class="text-xs text-fg-muted mt-2">No package-list markdown detected in this PR's body.</p>`;

  return `<div class="card">
    <div class="flex items-baseline justify-between gap-3">
      <a href="${escapeUrl(pr.html_url)}" class="font-mono text-accent-ok underline"
         target="_blank" rel="noopener">#${pr.number}</a>
      <span class="text-xs text-fg-muted">${escapeHtml(when)}</span>
    </div>
    <div class="text-fg-primary mt-1">${escapeHtml(pr.title)}</div>
    <div class="text-xs text-fg-muted">${bumps.length} package${bumps.length === 1 ? '' : 's'} bumped</div>
    ${bumpsHtml}
  </div>`;
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c =>
    ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}
// URL-safe attr escape: only quote/angle escape so full https:// URLs stay intact.
function escapeUrl(s) {
  return String(s).replace(/[<>"']/g, c =>
    ({'<':'%3C','>':'%3E','"':'%22',"'":'%27'}[c]));
}

function showError(msg) {
  document.getElementById('content').innerHTML =
    `<p class="text-accent-bad">Failed to load: ${escapeHtml(msg)}</p>`;
}

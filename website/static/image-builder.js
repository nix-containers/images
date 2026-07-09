(function () {
  'use strict';

  const BASE = window.SITE_BASE || '/';

  // Small curated list of common CLI tools that make useful base packages.
  // Users can type any nixpkgs attribute name — this list is just a hint.
  const SUGGESTED_BASES = [
    'age', 'ansible', 'awscli2', 'azure-cli', 'bash', 'buildah', 'busybox',
    'caddy', 'clickhouse', 'cmake', 'consul', 'coreutils', 'crane', 'curl',
    'dive', 'docker-compose', 'envoy', 'ffmpeg', 'flyctl', 'gcc', 'gh', 'git',
    'go', 'gnupg', 'go-task', 'google-cloud-sdk', 'grafana-loki',
    'grpcurl', 'haproxy', 'helm', 'httpie', 'jq', 'k9s', 'kafka',
    'kubectl', 'kubernetes-helm', 'kustomize', 'mariadb', 'mc',
    'memcached', 'minio', 'mongodb', 'mysql', 'neovim', 'nginx',
    'nodejs', 'openldap', 'openssh', 'openssl', 'opentelemetry-collector',
    'oras', 'pandoc', 'php', 'pnpm', 'podman', 'postgresql', 'prometheus',
    'python3', 'rabbitmq-server', 'redis', 'ruby', 'rustc', 'skopeo',
    'sqlite', 'strace', 'tcpdump', 'terraform', 'terragrunt', 'tmux',
    'traefik', 'trivy', 'valkey', 'vault', 'vim', 'wget', 'wireguard-tools',
    'yarn', 'yq-go', 'zig', 'zsh',
  ];

  const $ = (id) => document.getElementById(id);
  const baseInput = $('base-package');
  const extraInput = $('extra-packages');
  const extraSuggestions = $('extra-suggestions');
  const layersContainer = $('layers');
  const cmdOutput = $('cmd-output');
  const cmdStatus = $('cmd-status');
  const copyBtn = $('copy-cmd');
  const dataList = $('package-suggestions');
  const cvePreview = $('cve-preview');
  const cveRows = $('cve-rows');
  const cveTotals = $('cve-totals');
  const cveCaveat = $('cve-caveat');
  const extEnable = $('ext-enable');
  const extFields = $('ext-fields');
  const extName = $('ext-name');
  const extVersion = $('ext-version');
  const extUrl = $('ext-url');
  const extHash = $('ext-hash');
  const extInstallPath = $('ext-installpath');

  // Populate <datalist> for the base input (native browser autocomplete)
  for (const name of SUGGESTED_BASES) {
    const opt = document.createElement('option');
    opt.value = name;
    dataList.appendChild(opt);
  }

  // CVE index: name -> { critical, high, medium, total }
  // Fetched from /image-cve-index.json which render.py emits at build time.
  let cveIndex = null;
  fetch(BASE + 'image-cve-index.json')
    .then((r) => r.ok ? r.json() : null)
    .then((j) => { cveIndex = j || {}; render(); })
    .catch(() => { cveIndex = {}; });

  // Restore state from ?base=&layers=&extra=&ext_*  (or from sessionStorage)
  function readState() {
    const q = new URLSearchParams(location.search);
    const stored = (() => {
      try { return JSON.parse(sessionStorage.getItem('imgb') || '{}'); } catch { return {}; }
    })();
    const base = q.get('base') || stored.base || '';
    const extra = q.get('extra') || stored.extra || '';
    const layers = (q.get('layers') || stored.layers || '').split(/[,\s]+/).filter(Boolean);
    baseInput.value = base;
    extraInput.value = extra;
    layersContainer.querySelectorAll('input[data-layer]').forEach((cb) => {
      cb.checked = layers.includes(cb.dataset.layer);
    });
    // External-package state
    const ext = stored.ext || {};
    const on = q.get('ext_on') || ext.on || '';
    extEnable.checked = on === '1' || on === 'true';
    extName.value = q.get('ext_name') || ext.name || '';
    extVersion.value = q.get('ext_version') || ext.version || '';
    extUrl.value = q.get('ext_url') || ext.url || '';
    extHash.value = q.get('ext_hash') || ext.hash || '';
    extInstallPath.value = q.get('ext_installpath') || ext.installpath || '';
    extFields.classList.toggle('hidden', !extEnable.checked);
  }

  function writeState() {
    const layers = [...layersContainer.querySelectorAll('input[data-layer]:checked')]
      .map((cb) => cb.dataset.layer);
    const ext = {
      on: extEnable.checked ? '1' : '',
      name: extName.value.trim(),
      version: extVersion.value.trim(),
      url: extUrl.value.trim(),
      hash: extHash.value.trim(),
      installpath: extInstallPath.value.trim(),
    };
    const state = {
      base: baseInput.value.trim(),
      extra: extraInput.value.trim(),
      layers: layers.join(','),
      ext,
    };
    try { sessionStorage.setItem('imgb', JSON.stringify(state)); } catch {}
    const q = new URLSearchParams();
    if (state.base) q.set('base', state.base);
    if (state.extra) q.set('extra', state.extra);
    if (state.layers) q.set('layers', state.layers);
    if (ext.on) {
      q.set('ext_on', '1');
      for (const k of ['name', 'version', 'url', 'hash', 'installpath']) {
        if (ext[k]) q.set('ext_' + k, ext[k]);
      }
    }
    const qs = q.toString();
    const newUrl = location.pathname + (qs ? '?' + qs : '');
    history.replaceState(null, '', newUrl);
  }

  // Sanitize a package name to a valid nixpkgs attr-ish token.
  const IDENT = /^[a-zA-Z_][a-zA-Z0-9_+\-.]*$/;

  function currentPackages() {
    const base = baseInput.value.trim();
    const layerPkgs = new Set();
    for (const cb of layersContainer.querySelectorAll('input[data-layer]:checked')) {
      cb.dataset.packages.split(/\s+/).forEach((n) => n && layerPkgs.add(n));
    }
    const extras = extraInput.value.split(/[,\s]+/).map((s) => s.trim()).filter(Boolean);
    extras.forEach((n) => layerPkgs.add(n));
    return { base, extras: [...layerPkgs] };
  }

  function cveForName(name) {
    if (!cveIndex || !name) return null;
    return cveIndex[name] || null;
  }

  function renderCves(base, extras) {
    if (!cveIndex) {
      cvePreview.classList.add('hidden');
      return;
    }
    const rows = [];
    const totals = { critical: 0, high: 0, medium: 0, total: 0 };
    const unknown = [];

    const addRow = (name, kind) => {
      const s = cveForName(name);
      if (!s) { unknown.push(name); return; }
      totals.critical += s.critical;
      totals.high += s.high;
      totals.medium += s.medium;
      totals.total += s.total;
      rows.push({ name, kind, s });
    };

    if (base) addRow(base, 'base');
    for (const e of extras) addRow(e, 'extra');

    if (rows.length === 0) {
      cveRows.innerHTML =
        '<div class="text-fg-muted italic">' +
        'No selected package matches an image in this catalog — build locally and scan the result to see CVEs.' +
        '</div>';
      cveTotals.innerHTML = '';
      cveCaveat.textContent = '';
      cvePreview.classList.remove('hidden');
      return;
    }

    cveRows.innerHTML = rows.map((r) => {
      const { s, name, kind } = r;
      const pieces = [
        s.critical ? `<span class="text-accent-bad">${s.critical} crit</span>` : '',
        s.high     ? `<span class="text-accent-warn">${s.high} high</span>`    : '',
        s.medium   ? `<span class="text-fg-muted">${s.medium} med</span>`      : '',
      ].filter(Boolean).join(' · ');
      const zeroPill = pieces ? '' : `<span class="text-accent-ok">clean</span>`;
      const link = `<a href="${BASE}images/${encodeURIComponent(name)}/" class="hover:text-fg-primary">${name}</a>`;
      const label = kind === 'base' ? '(base)' : '(extra)';
      return `<div class="flex justify-between gap-3">
        <span>${link} <span class="text-fg-muted opacity-70">${label}</span></span>
        <span>${pieces}${zeroPill}</span>
      </div>`;
    }).join('');

    cveTotals.innerHTML = `
      <span>total: <span class="text-fg-primary">${totals.total}</span></span>
      <span>crit: <span class="${totals.critical ? 'text-accent-bad' : 'text-accent-ok'}">${totals.critical}</span></span>
      <span>high: <span class="${totals.high ? 'text-accent-warn' : 'text-accent-ok'}">${totals.high}</span></span>
      <span>medium: <span class="text-fg-primary">${totals.medium}</span></span>
    `;

    const notes = [];
    if (unknown.length) {
      notes.push(`Not in this catalog (no CVE data): ${unknown.join(', ')}.`);
    }
    notes.push(
      'Numbers reflect the most recent scan of the matching published image ' +
      '(same attr may be assembled differently). Actual count of your composed ' +
      'image depends on final layer overlap — scan the local build to confirm.'
    );
    cveCaveat.textContent = notes.join(' ');
    cvePreview.classList.remove('hidden');
  }

  function render() {
    const { base, extras } = currentPackages();

    if (!base) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = '(waiting for a base package)';
      copyBtn.disabled = true;
      cvePreview.classList.add('hidden');
      writeState();
      return;
    }
    if (!IDENT.test(base)) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = `(invalid base attr: “${base}”)`;
      copyBtn.disabled = true;
      cvePreview.classList.add('hidden');
      writeState();
      return;
    }
    const invalidExtras = extras.filter((e) => !IDENT.test(e));
    if (invalidExtras.length) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = `(invalid extras: ${invalidExtras.join(', ')})`;
      copyBtn.disabled = true;
      cvePreview.classList.add('hidden');
      writeState();
      return;
    }

    // External-package snippet — turns into a `let external = mkDerivation …`
    // binding used inside extraContents.
    const ext = extEnable.checked ? {
      name: extName.value.trim(),
      version: extVersion.value.trim() || '0.0.0',
      url: extUrl.value.trim(),
      hash: extHash.value.trim() || 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      installPath: (extInstallPath.value.trim() || '/bin').replace(/^\/*/, '/'),
    } : null;

    let extBinding = '';
    let extraContentsLine = '';
    if (ext && ext.name && ext.url) {
      const looksTarball = /\.(tar\.gz|tgz|tar\.xz|txz|tar\.bz2|tbz|zip)$/i.test(ext.url);
      const installBody = looksTarball
        ? `        # Extract-then-copy: sourceRoot="." keeps the extracted layout intact.
        mkdir -p $out${ext.installPath}
        cp -r . $out${ext.installPath}/
        find $out${ext.installPath} -type f -exec chmod +x {} \\; 2>/dev/null || true`
        : `        # Single-binary drop.
        install -Dm755 $src $out${ext.installPath}/${ext.name}`;
      extBinding = `    external = pkgs.stdenv.mkDerivation {
      pname = "external-${ext.name}";
      version = "${ext.version}";
      src = pkgs.fetchurl {
        url = "${ext.url}";
        hash = "${ext.hash}";
      };
      ${looksTarball ? 'sourceRoot = ".";' : 'dontUnpack = true;'}
      installPhase = ''
${installBody}
      '';
    };
`;
      extraContentsLine = `      extraContents = [ external ];\n`;
    }

    const imgName = `my-${base}`;
    const extraLine = extras.length
      ? `      extraPkgs = with pkgs; [ ${extras.join(' ')} ];\n`
      : '';

    const cmd = `nix build --impure --expr '
  let
    flake = builtins.getFlake "github:nix-containers/images";
    system = builtins.currentSystem;
    pkgs = flake.legacyPackages.\${system} or flake.inputs.nixpkgs.legacyPackages.\${system};
    mkImage = (flake.lib.\${system} or flake.lib.x86_64-linux).mkImage or (import \${flake}/lib/mkImage.nix {
      inherit (pkgs) lib busybox;
      base = import \${flake}/lib/base.nix { inherit pkgs; };
      nix2container = flake.inputs.nix2container.packages.\${system}.nix2container;
    });
${extBinding}  in mkImage {
    name = "${imgName}";
    drv = pkgs.${base};
${extraLine}${extraContentsLine}  }
'
# → ./result is the image; load into docker with:
#   docker load < ./result   # nix2container writes a docker-loadable tar${ext ? `
# If the sha256 was left blank, nix build will fail with the real hash on
# stderr — copy the "got:" value into the "sha256:" field and re-run.` : ''}`;

    cmdOutput.textContent = cmd;
    cmdStatus.textContent = `base = pkgs.${base}${extras.length ? ` · ${extras.length} extra` : ''}`;
    copyBtn.disabled = false;
    renderCves(base, extras);
    writeState();
  }

  copyBtn.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(cmdOutput.textContent);
      const orig = copyBtn.textContent;
      copyBtn.textContent = 'Copied';
      setTimeout(() => { copyBtn.textContent = orig; }, 1200);
    } catch {}
  });

  // Extras autocomplete. Native <datalist> only supports one full-input token,
  // but the extras field lets users chain several attrs (e.g. "kubectl helm jq").
  // We build a custom dropdown that suggests matches for the LAST token being
  // typed. Trigger: ≥2 chars in the current token.
  function currentExtraTokenRange() {
    const val = extraInput.value;
    const caret = extraInput.selectionStart ?? val.length;
    const before = val.slice(0, caret);
    const m = before.match(/(?:^|[\s,])([A-Za-z0-9_+\-.]*)$/);
    const token = m ? m[1] : '';
    const tokenStart = m ? caret - token.length : caret;
    return { token, tokenStart, caret };
  }

  function extraSuggestionsFor(token) {
    const t = token.toLowerCase();
    if (t.length < 2) return [];
    // Merge curated bases with every known nixpkgs attr that already appears
    // as a packaged image in this catalog (cveIndex keys). Broader coverage
    // than the base <datalist> so users can pick less-common tools too.
    const pool = new Set(SUGGESTED_BASES);
    if (cveIndex) Object.keys(cveIndex).forEach((n) => pool.add(n));
    const arr = [...pool];
    const pre = arr.filter((n) => n.toLowerCase().startsWith(t)).sort();
    const sub = arr.filter((n) => {
      const ln = n.toLowerCase();
      return ln.includes(t) && !ln.startsWith(t);
    }).sort();
    return [...pre, ...sub].slice(0, 12);
  }

  function refreshExtraSuggestions() {
    const { token, tokenStart, caret } = currentExtraTokenRange();
    const matches = extraSuggestionsFor(token);
    if (matches.length === 0) {
      extraSuggestions.classList.add('hidden');
      extraSuggestions.innerHTML = '';
      return;
    }
    extraSuggestions.innerHTML = matches.map((m) => {
      const cve = cveForName(m);
      const badge = cve
        ? (cve.critical
            ? `<span class="text-accent-bad ml-2">${cve.critical} crit</span>`
            : cve.high
              ? `<span class="text-accent-warn ml-2">${cve.high} high</span>`
              : `<span class="text-accent-ok ml-2">clean</span>`)
        : '';
      return `<li class="px-3 py-2 hover:bg-neutral-800 cursor-pointer text-sm font-mono flex justify-between"
                  data-name="${m}" data-start="${tokenStart}" data-end="${caret}">
                <span>${m}</span>${badge}
              </li>`;
    }).join('');
    extraSuggestions.classList.remove('hidden');
  }

  extraSuggestions.addEventListener('mousedown', (ev) => {
    ev.preventDefault(); // keep focus on the input while inserting
    const li = ev.target.closest('li[data-name]');
    if (!li) return;
    const name = li.dataset.name;
    const start = parseInt(li.dataset.start, 10);
    const end = parseInt(li.dataset.end, 10);
    const v = extraInput.value;
    extraInput.value = v.slice(0, start) + name + ' ' + v.slice(end);
    const newCaret = start + name.length + 1;
    extraInput.setSelectionRange(newCaret, newCaret);
    extraInput.focus();
    extraSuggestions.classList.add('hidden');
    render();
  });

  extraInput.addEventListener('input', () => { refreshExtraSuggestions(); render(); });
  extraInput.addEventListener('keydown', (ev) => {
    if (ev.key === 'Escape') extraSuggestions.classList.add('hidden');
  });
  extraInput.addEventListener('blur', () => {
    setTimeout(() => extraSuggestions.classList.add('hidden'), 150);
  });

  baseInput.addEventListener('input', render);
  layersContainer.addEventListener('change', render);

  // External-package section toggle + field wiring
  extEnable.addEventListener('change', () => {
    extFields.classList.toggle('hidden', !extEnable.checked);
    render();
  });
  [extName, extVersion, extUrl, extHash, extInstallPath].forEach((el) => {
    el.addEventListener('input', render);
  });

  readState();
  render();
})();

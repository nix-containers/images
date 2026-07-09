(function () {
  'use strict';

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
  const layersContainer = $('layers');
  const cmdOutput = $('cmd-output');
  const cmdStatus = $('cmd-status');
  const copyBtn = $('copy-cmd');
  const dataList = $('package-suggestions');

  // Populate <datalist>
  for (const name of SUGGESTED_BASES) {
    const opt = document.createElement('option');
    opt.value = name;
    dataList.appendChild(opt);
  }

  // Restore state from ?base=&layers=&extra=  (or from sessionStorage)
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
  }

  function writeState() {
    const layers = [...layersContainer.querySelectorAll('input[data-layer]:checked')]
      .map((cb) => cb.dataset.layer);
    const state = {
      base: baseInput.value.trim(),
      extra: extraInput.value.trim(),
      layers: layers.join(','),
    };
    try { sessionStorage.setItem('imgb', JSON.stringify(state)); } catch {}
    // Also update the URL (without reload) so the state is copy-shareable.
    const q = new URLSearchParams();
    if (state.base) q.set('base', state.base);
    if (state.extra) q.set('extra', state.extra);
    if (state.layers) q.set('layers', state.layers);
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

  function render() {
    const { base, extras } = currentPackages();

    if (!base) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = '(waiting for a base package)';
      copyBtn.disabled = true;
      writeState();
      return;
    }
    if (!IDENT.test(base)) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = `(invalid base attr: “${base}”)`;
      copyBtn.disabled = true;
      writeState();
      return;
    }
    const invalidExtras = extras.filter((e) => !IDENT.test(e));
    if (invalidExtras.length) {
      cmdOutput.textContent = '';
      cmdStatus.textContent = `(invalid extras: ${invalidExtras.join(', ')})`;
      copyBtn.disabled = true;
      writeState();
      return;
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
  in mkImage {
    name = "${imgName}";
    drv = pkgs.${base};
${extraLine}  }
'
# → ./result is the image; load into docker with:
#   docker load < ./result   # nix2container writes a docker-loadable tar`;

    cmdOutput.textContent = cmd;
    cmdStatus.textContent = `base = pkgs.${base}${extras.length ? ` · ${extras.length} extra` : ''}`;
    copyBtn.disabled = false;
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

  [baseInput, extraInput].forEach((el) => el.addEventListener('input', render));
  layersContainer.addEventListener('change', render);

  readState();
  render();
})();

let allImages = [];
let filteredImages = [];
let criticalsOnly = false;
let newCvesOnly = false;
let bigbangSet = new Set();
let exampleClusterSet = new Set();
let reframeAwaiting = true;      // "awaiting upstream fix" reframe — on by default
let reframeAwaitingNix = true;   // "awaiting nixpkgs package" reframe — on by default
let siteData = null;
const BASE = window.SITE_BASE || '/';

document.addEventListener('DOMContentLoaded', () => {
  loadImages();
  loadBigbang();
  loadExampleCluster();
  document.getElementById('search').addEventListener('input', filter);
  document.getElementById('category-filter').addEventListener('change', filter);
  document.getElementById('chart-filter').addEventListener('change', filter);
  const bbEl = document.getElementById('bigbang-filter');
  if (bbEl) bbEl.addEventListener('change', filter);
  const ecEl = document.getElementById('example-cluster-filter');
  if (ecEl) ecEl.addEventListener('change', filter);
  const zcEl = document.getElementById('zerocve-filter');
  if (zcEl) zcEl.addEventListener('change', filter);
  const awEl = document.getElementById('awaiting-filter');
  if (awEl) {
    reframeAwaiting = awEl.checked;
    awEl.addEventListener('change', () => {
      reframeAwaiting = awEl.checked;
      if (siteData) updateStats(siteData);
      filter();
    });
  }
  const awNixEl = document.getElementById('awaiting-nix-filter');
  if (awNixEl) {
    reframeAwaitingNix = awNixEl.checked;
    awNixEl.addEventListener('change', () => {
      reframeAwaitingNix = awNixEl.checked;
      if (siteData) updateStats(siteData);
      filter();
    });
  }
  const critCard = document.getElementById('critical-card');
  if (critCard) {
    const toggleCrit = () => {
      criticalsOnly = !criticalsOnly;
      critCard.classList.toggle('border-accent-bad', criticalsOnly);
      critCard.setAttribute('aria-pressed', String(criticalsOnly));
      filter();
      if (criticalsOnly) {
        document.getElementById('images-container')
          .scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    };
    critCard.addEventListener('click', toggleCrit);
    critCard.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleCrit(); }
    });
  }
  const newCard = document.getElementById('new-cves-card');
  if (newCard) {
    const toggleNew = () => {
      newCvesOnly = !newCvesOnly;
      newCard.classList.toggle('border-accent-warn', newCvesOnly);
      newCard.setAttribute('aria-pressed', String(newCvesOnly));
      filter();
      if (newCvesOnly) {
        document.getElementById('images-container')
          .scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    };
    newCard.addEventListener('click', toggleNew);
    newCard.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleNew(); }
    });
  }
  fetchAutoUpdateCount();
});

// Populate the "Auto-updates today" homepage card with two counts: number
// of merged auto-update PRs, and the number of UNIQUE packages bumped
// across those PRs (deduped — if a package appears in multiple PRs it
// counts once). Card links to /auto-updates/ for the full breakdown.
async function fetchAutoUpdateCount() {
  const prsEl = document.getElementById('auto-updates-count');
  const bumpsEl = document.getElementById('auto-updates-bumps');
  if (!prsEl) return;
  try {
    const since = new Date(Date.now() - 24 * 3600 * 1000).toISOString();
    const url = 'https://api.github.com/search/issues?q=' +
      encodeURIComponent(
        'repo:nix-containers/images is:pr is:merged ' +
        '("deps:" OR "chore(deps)" OR "auto-update" OR "automated package") ' +
        'merged:>=' + since
      );
    const r = await fetch(url, { headers: { 'Accept': 'application/vnd.github+json' } });
    if (!r.ok) throw new Error('gh api ' + r.status);
    const data = await r.json();
    const prs = data.items || [];
    prsEl.textContent = prs.length;

    if (bumpsEl) {
      // Same regex the /auto-updates/ page uses: "- `pkg` from → to" (or
      // variants). GitHub search returns each PR with its body already
      // populated, so this needs no extra API calls.
      const bumpRe = /^\s*[-*]\s+`?([\w./+-]+)`?(?:\s+[\w.+-]+\s*(?:→|->|to)\s*[\w.+-]+)?\s*$/;
      const uniq = new Set();
      for (const pr of prs) {
        const body = pr.body || '';
        for (const line of body.split(/\r?\n/)) {
          const m = line.match(bumpRe);
          if (m) uniq.add(m[1]);
        }
      }
      bumpsEl.textContent = uniq.size;
    }
  } catch (e) {
    prsEl.textContent = '?';
    if (bumpsEl) bumpsEl.textContent = '?';
    console.warn('auto-updates fetch failed:', e);
  }
}

// Two independent reframes exclude CVEs the auto-updater can't reach right now,
// each shown separately under a badge. "awaiting upstream" = bundled/compiled-in
// deps only the app maintainer can fix; "awaiting nixpkgs" = deps nixpkgs ships
// as its own package, fixed by a nixpkgs bump + our rebuild. Both on (default)
// reproduces the fully-reframed count; toggle either off to fold that bucket
// back into the visible total.
function imgCritical(i) {
  const c = (i.scan && i.scan.critical) || 0;
  return c - (reframeAwaiting ? ((i.scan && i.scan.awaitingUpstreamCritical) || 0) : 0)
           - (reframeAwaitingNix ? ((i.scan && i.scan.awaitingNixCritical) || 0) : 0);
}

function imgHigh(i) {
  const h = (i.scan && i.scan.high) || 0;
  return h - (reframeAwaiting ? ((i.scan && i.scan.awaitingUpstreamHigh) || 0) : 0)
           - (reframeAwaitingNix ? ((i.scan && i.scan.awaitingNixHigh) || 0) : 0);
}

function imgAwaitingUpstream(i) {
  return ((i.scan && i.scan.awaitingUpstreamCritical) || 0) +
         ((i.scan && i.scan.awaitingUpstreamHigh) || 0);
}

function imgAwaitingNix(i) {
  return ((i.scan && i.scan.awaitingNixCritical) || 0) +
         ((i.scan && i.scan.awaitingNixHigh) || 0);
}

function imgNewCves3d(i) {
  return (i.scan && i.scan.newCves3d) || 0;
}

async function loadImages() {
  try {
    const r = await fetch(BASE + 'images-data.json');
    const data = await r.json();
    allImages = data.images || [];
    siteData = data;
    filteredImages = [...allImages];
    updateStats(data);
    updateReactiveStats(allImages);
    populateCategoryFilter();
    render();
  } catch (e) {
    showError('Failed to load images-data.json: ' + e.message);
  }
}

// Load the Big Bang image set (our catalog names that ship in a Big Bang
// release). Powers the "Used by Big Bang" filter; if unavailable the filter
// simply matches nothing.
async function loadBigbang() {
  try {
    const r = await fetch(BASE + 'static/bigbang-images.json');
    bigbangSet = new Set(await r.json());
  } catch (e) { /* no-op */ }
}

// Load the Example Cluster image set — images we actually run on our
// platform clusters. Same shape as bigbang-images.json; drives the
// "Example Cluster" filter. Edit static/example-cluster-images.json to
// add/remove images from the set.
async function loadExampleCluster() {
  try {
    const r = await fetch(BASE + 'static/example-cluster-images.json');
    exampleClusterSet = new Set(await r.json());
  } catch (e) { /* no-op */ }
}

function updateStats(data) {
  document.getElementById('total-images').textContent = data.totalCount ?? allImages.length;
  document.getElementById('tested-images').textContent =
    allImages.filter(i => i.hasTest).length;
  document.getElementById('categories-count').textContent =
    new Set(allImages.map(i => i.category)).size;
  const totalCritical = allImages.reduce((acc, i) => acc + imgCritical(i), 0);
  document.getElementById('critical-count').textContent = totalCritical;
  const totalHigh = allImages.reduce((acc, i) => acc + imgHigh(i), 0);
  const highEl = document.getElementById('high-count');
  if (highEl) highEl.textContent = totalHigh.toLocaleString();

  // Fresh disclosures: distinct CVEs first published in the last 3 days.
  const newCveEl = document.getElementById('new-cves-3d');
  if (newCveEl) newCveEl.textContent = (data.newCves3d ?? 0).toLocaleString();

  // Auto-updater impact: how many of these CRIT+HIGH CVEs will clear on the
  // next auto-update cycle (nvchecker sees a fix, or the image is
  // nixpkgs-tracked and moves with the flake).
  const afEl = document.getElementById('auto-fix-count');
  if (afEl) {
    const afCrit = data.autoFixCritical ?? 0;
    const afHigh = data.autoFixHigh ?? 0;
    const afTotal = afCrit + afHigh;
    const grand = totalCritical + totalHigh;
    const pct = grand > 0 ? Math.round(100 * afTotal / grand) : 0;
    afEl.textContent = afTotal > 0
      ? `${afTotal.toLocaleString()} auto-fix pending (${pct}%)`
      : '';
  }

  // Last scan: the most recent per-image scannedAt across the catalog, shown
  // with an exact timestamp and an "N hours ago" relative age.
  const scanEl = document.getElementById('last-scan');
  if (scanEl) {
    const times = allImages
      .map(i => i.scan && i.scan.scannedAt)
      .filter(Boolean);
    if (times.length) {
      const latest = times.reduce((a, b) => (a > b ? a : b));
      const d = new Date(latest);
      const ageMs = Date.now() - d.getTime();
      const hours = ageMs / 3.6e6;
      const ago = hours < 1
        ? `${Math.max(0, Math.round(hours * 60))} min ago`
        : (hours < 48
            ? `${hours.toFixed(1)} h ago`
            : `${Math.round(hours / 24)} d ago`);
      scanEl.textContent = `Last scan: ${d.toLocaleString()} (${ago})`;
    } else {
      scanEl.textContent = 'Last scan: unknown';
    }
  }

  // Size summary. Three numbers from render.py:
  //   compressed  — on-the-wire pull cost (gzip'd layer sum)
  //   uncompressed — extracted disk cost (decompressed layer sum)
  //   upstream    — estimate via 4.5x multiplier on compressed
  const ours = data.totalCompressedBytes || 0;
  const oursUnc = data.totalUncompressedBytes || 0;
  const upstream = data.estimatedUpstreamBytes || 0;
  const multiplier = data.upstreamSizeMultiplier || 0;
  const sizeEl = document.getElementById('total-size');
  const uncEl = document.getElementById('total-uncompressed');
  const cmpEl = document.getElementById('upstream-comparison');
  if (ours > 0) {
    sizeEl.textContent = humanBytes(ours);
    if (uncEl) {
      uncEl.textContent = oursUnc > 0 ? `${humanBytes(oursUnc)} extracted` : '';
    }
    if (cmpEl && upstream > 0 && multiplier > 0) {
      cmpEl.textContent =
        `~${humanBytes(upstream)} upstream • ${multiplier}× smaller`;
    }
  } else if (sizeEl) {
    sizeEl.textContent = '–';
    if (uncEl) uncEl.textContent = '';
    if (cmpEl) cmpEl.textContent = 'No tags-data available';
  }

  // Packages stat card. Two numbers: unique names (e.g. one entry per
  // openssl regardless of version), and total instances (raw sum across
  // every image's SBOM). The card links to the /packages/ directory
  // so a click drills into the searchable list.
  const pkgUnique = data.totalPackageUniqueNames || 0;
  const pkgInstances = data.totalPackageInstances || 0;
  const pkgEl = document.getElementById('total-packages');
  const pkgInstEl = document.getElementById('total-package-instances');
  if (pkgEl) {
    pkgEl.textContent = pkgUnique > 0 ? pkgUnique.toLocaleString() : '–';
  }
  // Mirror the packages total under the Total images card (requested): unique
  // names as the headline, total instances as a sub-line.
  const pkgTotEl = document.getElementById('total-images-packages');
  if (pkgTotEl) pkgTotEl.textContent = pkgUnique > 0 ? pkgUnique.toLocaleString() : '–';
  const pkgTotInstEl = document.getElementById('total-images-instances');
  if (pkgTotInstEl && pkgInstances > 0) {
    pkgTotInstEl.textContent = `${pkgInstances.toLocaleString()} instances`;
  }
  if (pkgInstEl && pkgInstances > 0) {
    pkgInstEl.textContent = `${pkgInstances.toLocaleString()} instances`;
  }

  // Charts stat card. Async fetch of /charts.json — this file is only
  // emitted when render.py runs with --charts-data (i.e. the charts/
  // directory exists), so an absent JSON just means "no charts yet"
  // and we leave the card at "–".
  const chartsEl = document.getElementById('total-charts');
  if (chartsEl) {
    fetch(BASE + 'charts.json')
      .then(r => r.ok ? r.json() : null)
      .then(d => {
        if (d && d.totalCount) chartsEl.textContent = d.totalCount.toLocaleString();
      })
      .catch(() => {});
  }
}

function humanBytes(n) {
  if (!n || n <= 0) return '–';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  let v = n;
  let i = 0;
  while (v >= 1024 && i < units.length - 1) { v /= 1024; i++; }
  // Same convention as render.py's Tags-table size column.
  return i >= 2 ? `${v.toFixed(1)} ${units[i]}` : `${Math.round(v)} ${units[i]}`;
}

function populateCategoryFilter() {
  const cats = [...new Set(allImages.map(i => i.category))].sort();
  // category -> description, derived from the images' categoryDesc field.
  const desc = {};
  allImages.forEach(i => { if (i.category && i.categoryDesc) desc[i.category] = i.categoryDesc; });
  const sel = document.getElementById('category-filter');
  cats.forEach(c => {
    const opt = document.createElement('option');
    opt.value = c;
    opt.textContent = c;
    if (desc[c]) opt.title = desc[c];   // hover text explaining the category
    sel.appendChild(opt);
  });
}

function filter() {
  const q = document.getElementById('search').value.toLowerCase();
  const cat = document.getElementById('category-filter').value;
  const chartsOnly = document.getElementById('chart-filter').checked;
  const bbEl = document.getElementById('bigbang-filter');
  const bigbangOnly = bbEl && bbEl.checked;
  const ecEl = document.getElementById('example-cluster-filter');
  const exampleClusterOnly = ecEl && ecEl.checked;
  const zcEl = document.getElementById('zerocve-filter');
  const zeroCveOnly = zcEl && zcEl.checked;
  filteredImages = allImages.filter(i => {
    const matchesQ = !q ||
      i.name.toLowerCase().includes(q) ||
      (i.description || '').toLowerCase().includes(q);
    const matchesCat = !cat || i.category === cat;
    const matchesChart = !chartsOnly ||
      (Array.isArray(i.usedByCharts) && i.usedByCharts.length > 0);
    const matchesBigbang = !bigbangOnly || bigbangSet.has(i.name);
    const matchesExampleCluster = !exampleClusterOnly || exampleClusterSet.has(i.name);
    // The Critical/High stat card filters to images with either severity.
    const matchesCrit = !criticalsOnly || imgCritical(i) > 0 || imgHigh(i) > 0;
    // The "New CVEs (3d)" stat card filters to images with a fresh disclosure.
    const matchesNew = !newCvesOnly || imgNewCves3d(i) > 0;
    // "Zero CVEs": scan exists AND every severity is zero. Missing scan ≠ clean,
    // so unscanned images are excluded (mirrors the 0 CVE badge semantics).
    const matchesZeroCve = !zeroCveOnly || (i.scan && i.scan.total === 0);
    return matchesQ && matchesCat && matchesChart && matchesBigbang && matchesExampleCluster && matchesCrit && matchesNew && matchesZeroCve;
  });
  // Surface the worst offenders first: by critical count, then high count.
  if (criticalsOnly) {
    filteredImages.sort((a, b) =>
      (imgCritical(b) - imgCritical(a)) || (imgHigh(b) - imgHigh(a)));
  } else if (newCvesOnly) {
    filteredImages.sort((a, b) => imgNewCves3d(b) - imgNewCves3d(a));
  }
  // Stat cards (total images, CVEs, packages) reflect the filtered set.
  updateReactiveStats(filteredImages);
  render();
}

// Recompute the filter-sensitive stat cards from a given image set. Called on
// load (all images) and after every filter change (the filtered subset).
function updateReactiveStats(imgs) {
  const ti = document.getElementById('total-images');
  if (ti) ti.textContent = imgs.length.toLocaleString();
  const crit = imgs.reduce((a, i) => a + imgCritical(i), 0);
  const high = imgs.reduce((a, i) => a + imgHigh(i), 0);
  const ce = document.getElementById('critical-count');
  if (ce) ce.textContent = crit.toLocaleString();
  const he = document.getElementById('high-count');
  if (he) he.textContent = high.toLocaleString();
  // Package INSTANCES react to the filtered set (sum of per-image counts).
  // The unique-NAME totals aren't recomputable per-filter, so leave those to
  // updateStats — overwriting them here with the instances sum was the bug that
  // made the "Unique packages" card show the instances number.
  const pkgs = imgs.reduce((a, i) => a + (i.packageCount || 0), 0);
  const disp = pkgs > 0 ? `${pkgs.toLocaleString()} instances` : '';
  const pie = document.getElementById('total-package-instances');
  if (pie) pie.textContent = disp;
  const pie2 = document.getElementById('total-images-instances');
  if (pie2) pie2.textContent = disp;
}

function render() {
  const c = document.getElementById('images-container');
  const counter = document.getElementById('results-count');
  if (counter) {
    const shown = filteredImages.length;
    const total = allImages.length;
    if (criticalsOnly) {
      const totalCrit = filteredImages.reduce((a, i) => a + imgCritical(i), 0);
      const totalHi = filteredImages.reduce((a, i) => a + imgHigh(i), 0);
      counter.textContent =
        `${shown.toLocaleString()} image${shown === 1 ? '' : 's'} with `
        + `${totalCrit.toLocaleString()} critical + ${totalHi.toLocaleString()} high CVEs `
        + `— click any image for its CVE list`;
    } else {
      counter.textContent = shown === total
        ? `Showing all ${total.toLocaleString()} images`
        : `Showing ${shown.toLocaleString()} of ${total.toLocaleString()} images`;
    }
  }
  if (filteredImages.length === 0) {
    c.innerHTML = `<div class="col-span-full text-center py-12 text-fg-muted">
      No images match your filters.
    </div>`;
    return;
  }
  c.innerHTML = filteredImages.map(i => {
    // Status dot: RED when the latest scan found critical CVEs (this
    // overrides freshness — a fresh-but-vulnerable image is not "good"),
    // otherwise GREEN when scan + sbom + dep-check are all recent (≤7d).
    const criticalCount = imgCritical(i);
    const dot = criticalCount > 0
      ? `<span class="inline-block w-2 h-2 rounded-full bg-accent-bad mr-2 align-middle"
               title="${criticalCount} critical CVE${criticalCount === 1 ? '' : 's'} in the latest scan"></span>`
      : (i.freshness && i.freshness.isFresh)
        ? `<span class="inline-block w-2 h-2 rounded-full bg-accent-ok mr-2 align-middle"
                 title="Fresh data: scanned, SBOM available, deps checked within 7 days"></span>`
        : '';
    // Rank from IMAGE-POPULARITY.md, when present.
    const rank = (i.popularity && i.popularity.rank)
      ? `<span class="text-xs text-fg-muted font-mono">#${i.popularity.rank}</span>`
      : '';
    // "Nix" badge when the image packages a tool directly from nixpkgs.
    const nixBadge = i.fromNixpkgs
      ? `<span class="badge-nix" title="Packaged directly from nixpkgs">Nix</span>`
      : '';
    // "Scaffold" badge: placeholder image that isn't built out yet — contains
    // only base packages, not the named software. Flagged so the catalog
    // doesn't imply it ships the tool.
    const scaffoldBadge = i.scaffold
      ? `<span class="badge bg-fg-muted/20 text-fg-muted font-mono"
               title="Scaffold — placeholder not yet built with the actual software">scaffold</span>`
      : '';
    // "Good Upstream" badge: this catalog entry references a maintained OSS
    // upstream image directly (not built or hosted by us — pull the upstream).
    const upstreamBadge = i.upstreamImage
      ? `<span class="badge-nix" title="Good upstream — pull directly: ${escapeAttr(i.upstreamImage)}">↑ upstream</span>`
      : '';
    // "0 CVE" badge: scan exists and reported zero vulnerabilities at
    // every severity level. Only shown when we have actual scan data —
    // missing scan ≠ zero CVE.
    const zeroCve = (i.scan && i.scan.total === 0)
      ? `<span class="badge-zero-cve" title="No known CVEs in the latest scan">0 CVE</span>`
      : '';
    // "★ 0 CVE upstream" golden badge: the project's official upstream image
    // scans clean (0 critical/high/medium). Gold-standard upstream posture,
    // distinct from our own emerald build badge above.
    const zeroCveUpstream = i.upstreamZeroCve
      ? `<span class="badge-zero-cve-upstream" title="Gold-standard upstream — the official image scans clean${i.upstreamCveRef ? ' (' + escapeAttr(i.upstreamCveRef) + ')' : ''}">★ 0 CVE upstream</span>`
      : '';
    // Critical-CVE count badge — links straight to the image's vulnerabilities.
    const critBadge = criticalCount > 0
      ? `<span class="badge bg-accent-bad/20 text-accent-bad font-mono"
               title="${criticalCount} critical CVE${criticalCount === 1 ? '' : 's'} — click the image to see them">${criticalCount} crit</span>`
      : '';
    // High-CVE count badge (only in the criticals/highs filtered view, to
    // avoid cluttering every card in the full catalog).
    const highCount = imgHigh(i);
    // "awaiting" badges — CVEs the auto-updater can't reach, split by who ships
    // the fix. Each shows only while its reframe is on and its count > 0.
    const awaitUpCount = reframeAwaiting ? imgAwaitingUpstream(i) : 0;
    const awaitNixCount = reframeAwaitingNix ? imgAwaitingNix(i) : 0;
    const awaitUpBadge = awaitUpCount > 0
      ? `<span class="badge bg-neutral-700 text-neutral-300 font-mono"
               title="${awaitUpCount} critical/high CVE${awaitUpCount === 1 ? '' : 's'} in bundled/compiled-in deps — the app's upstream maintainer must fix, not counted against us">⏳ ${awaitUpCount} awaiting upstream</span>`
      : '';
    const awaitNixBadge = awaitNixCount > 0
      ? `<span class="badge bg-sky-900 text-sky-300 font-mono"
               title="${awaitNixCount} critical/high CVE${awaitNixCount === 1 ? '' : 's'} in nixpkgs-shipped deps — fixed by a nixpkgs bump + rebuild, not counted against us">🔧 ${awaitNixCount} awaiting nixpkgs</span>`
      : '';
    const awaitBadge = awaitUpBadge + awaitNixBadge;
    const highBadge = (criticalsOnly && highCount > 0)
      ? `<span class="badge bg-accent-warn/20 text-accent-warn font-mono"
               title="${highCount} high CVE${highCount === 1 ? '' : 's'} — click the image to see them">${highCount} high</span>`
      : '';
    // Show the actual semver when we have it (resolved from the
    // pushed :version tag via tags-data). Falls back to "latest" only
    // when no real version is known — bare "latest" is uninformative
    // in the catalog so we hide it whenever possible.
    const v = (i.version || '').trim();
    const hasRealVersion = v && v !== 'latest' && !v.startsWith('dynamic-');
    const fullVer = hasRealVersion ? v : 'latest';
    // Some images carry a bare content digest (e.g. sha256-<64 hex>) instead of
    // a semver — that unbroken string overflows the card. Show a short prefix
    // with an ellipsis and keep the full value on hover.
    const shownVer = /^sha256-[0-9a-f]{16,}$/i.test(fullVer)
      ? fullVer.slice(0, 'sha256-'.length + 12) + '…'
      : fullVer;
    const versionLine = escapeHtml(shownVer);
    const versionTitle = shownVer !== fullVer ? ` title="${escapeAttr(fullVer)}"` : '';
    return `
    <a href="${BASE}images/${escapeAttr(i.name)}/"
       class="card block">
      <div class="flex items-center justify-between mb-2">
        <div class="font-mono font-bold text-fg-primary">${dot}${escapeHtml(i.name)}</div>
        <div class="flex items-center gap-2">
          ${rank}
          ${critBadge}
          ${highBadge}
          ${awaitBadge}
          ${zeroCveUpstream}
          ${zeroCve}
          ${nixBadge}
          ${upstreamBadge}
          ${scaffoldBadge}
          <span class="badge-cat-${escapeAttr(i.categorySlug || 'unknown')}" title="${escapeAttr(i.categoryDesc || '')}">${escapeHtml(i.category || 'unknown')}</span>
        </div>
      </div>
      <p class="text-sm text-fg-muted line-clamp-2">${escapeHtml(i.description || '')}</p>
      <div class="mt-3 text-xs text-fg-muted font-mono truncate"${versionTitle}>${versionLine}</div>
    </a>
  `;}).join('');
}

function escapeHtml(s) {
  const div = document.createElement('div');
  div.textContent = s;
  return div.innerHTML;
}

function escapeAttr(s) {
  return String(s).replace(/[^\w-]/g, '');
}

function showError(msg) {
  document.getElementById('images-container').innerHTML =
    `<div class="col-span-full text-center py-12 text-accent-bad">${escapeHtml(msg)}</div>`;
}

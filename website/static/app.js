let allImages = [];
let filteredImages = [];
let criticalsOnly = false;
const BASE = window.SITE_BASE || '/';

document.addEventListener('DOMContentLoaded', () => {
  loadImages();
  document.getElementById('search').addEventListener('input', filter);
  document.getElementById('category-filter').addEventListener('change', filter);
  document.getElementById('chart-filter').addEventListener('change', filter);
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

function imgCritical(i) {
  return (i.scan && i.scan.critical) || 0;
}

function imgHigh(i) {
  return (i.scan && i.scan.high) || 0;
}

async function loadImages() {
  try {
    const r = await fetch(BASE + 'images-data.json');
    const data = await r.json();
    allImages = data.images || [];
    filteredImages = [...allImages];
    updateStats(data);
    populateCategoryFilter();
    render();
  } catch (e) {
    showError('Failed to load images-data.json: ' + e.message);
  }
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
  filteredImages = allImages.filter(i => {
    const matchesQ = !q ||
      i.name.toLowerCase().includes(q) ||
      (i.description || '').toLowerCase().includes(q);
    const matchesCat = !cat || i.category === cat;
    const matchesChart = !chartsOnly ||
      (Array.isArray(i.usedByCharts) && i.usedByCharts.length > 0);
    // The Critical/High stat card filters to images with either severity.
    const matchesCrit = !criticalsOnly || imgCritical(i) > 0 || imgHigh(i) > 0;
    return matchesQ && matchesCat && matchesChart && matchesCrit;
  });
  // Surface the worst offenders first: by critical count, then high count.
  if (criticalsOnly) {
    filteredImages.sort((a, b) =>
      (imgCritical(b) - imgCritical(a)) || (imgHigh(b) - imgHigh(a)));
  }
  render();
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
    const criticalCount = (i.scan && i.scan.critical) || 0;
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
    // Critical-CVE count badge — links straight to the image's vulnerabilities.
    const critBadge = criticalCount > 0
      ? `<span class="badge bg-accent-bad/20 text-accent-bad font-mono"
               title="${criticalCount} critical CVE${criticalCount === 1 ? '' : 's'} — click the image to see them">${criticalCount} crit</span>`
      : '';
    // High-CVE count badge (only in the criticals/highs filtered view, to
    // avoid cluttering every card in the full catalog).
    const highCount = (i.scan && i.scan.high) || 0;
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
    const versionLine = hasRealVersion ? escapeHtml(v) : 'latest';
    return `
    <a href="${BASE}images/${escapeAttr(i.name)}/"
       class="card block">
      <div class="flex items-center justify-between mb-2">
        <div class="font-mono font-bold text-fg-primary">${dot}${escapeHtml(i.name)}</div>
        <div class="flex items-center gap-2">
          ${rank}
          ${critBadge}
          ${highBadge}
          ${zeroCve}
          ${nixBadge}
          ${upstreamBadge}
          ${scaffoldBadge}
          <span class="badge-cat-${escapeAttr(i.categorySlug || 'unknown')}" title="${escapeAttr(i.categoryDesc || '')}">${escapeHtml(i.category || 'unknown')}</span>
        </div>
      </div>
      <p class="text-sm text-fg-muted line-clamp-2">${escapeHtml(i.description || '')}</p>
      <div class="mt-3 text-xs text-fg-muted font-mono">${versionLine}</div>
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

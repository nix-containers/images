let allPackages = [];
let filteredPackages = [];
const BASE = window.SITE_BASE || '/';

document.addEventListener('DOMContentLoaded', () => {
  loadPackages();
  document.getElementById('search').addEventListener('input', filter);
  document.getElementById('type-filter').addEventListener('change', filter);

  // Honor ?q=<name> from URL so links from per-image SBOM tables land
  // pre-filtered (e.g. /packages/?q=openssl).
  const params = new URLSearchParams(window.location.search);
  const q = params.get('q');
  if (q) {
    document.getElementById('search').value = q;
  }
});

async function loadPackages() {
  try {
    const r = await fetch(BASE + 'packages.json');
    const data = await r.json();
    allPackages = data.packages || [];
    filteredPackages = [...allPackages];
    updateStats(data);
    populateTypeFilter();
    filter();
  } catch (e) {
    showError('Failed to load packages.json: ' + e.message);
  }
}

function updateStats(data) {
  document.getElementById('unique-names').textContent =
    (data.uniqueNames ?? 0).toLocaleString();
  document.getElementById('total-entries').textContent =
    (data.totalEntries ?? 0).toLocaleString();
  document.getElementById('total-instances').textContent =
    (data.totalInstances ?? 0).toLocaleString();
}

function populateTypeFilter() {
  const types = [...new Set(allPackages.map(p => p.type).filter(Boolean))].sort();
  const sel = document.getElementById('type-filter');
  types.forEach(t => {
    const opt = document.createElement('option');
    opt.value = t;
    opt.textContent = t;
    sel.appendChild(opt);
  });
}

function filter() {
  const q = document.getElementById('search').value.toLowerCase().trim();
  const typeF = document.getElementById('type-filter').value;
  filteredPackages = allPackages.filter(p => {
    if (typeF && p.type !== typeF) return false;
    if (!q) return true;
    return p.name.toLowerCase().includes(q) ||
           (p.version || '').toLowerCase().includes(q);
  });
  render();
}

function render() {
  const c = document.getElementById('packages-container');
  const counter = document.getElementById('results-count');
  if (counter) {
    counter.textContent = filteredPackages.length === allPackages.length
      ? `Showing all ${allPackages.length.toLocaleString()} packages`
      : `Showing ${filteredPackages.length.toLocaleString()} of ${allPackages.length.toLocaleString()} packages`;
  }
  if (filteredPackages.length === 0) {
    c.innerHTML =
      '<div class="text-center py-12 text-fg-muted">No packages match your filter.</div>';
    return;
  }

  // Cap rendered DOM. A 3000-image fleet can yield 10k+ entries; the
  // page becomes janky if we render all of them at once. The search
  // input narrows the set quickly enough that this cap is invisible
  // in normal use.
  const CAP = 500;
  const shown = filteredPackages.slice(0, CAP);
  const truncatedNote = filteredPackages.length > CAP
    ? `<p class="text-fg-muted text-xs mb-3 italic">
         Showing first ${CAP.toLocaleString()} of ${filteredPackages.length.toLocaleString()} matches. Narrow the search to see more.
       </p>`
    : '';

  c.innerHTML = truncatedNote + shown.map(p => {
    const imagesPeek = p.images.slice(0, 6).map(img =>
      `<a href="${BASE}images/${escapeAttr(img)}/"
         class="inline-block text-xs font-mono bg-bg-input px-2 py-0.5 rounded mr-1 mb-1 text-fg-primary hover:bg-neutral-700">${escapeHtml(img)}</a>`
    ).join('');
    const moreCount = Math.max(0, p.images.length - 6);
    const moreText = moreCount > 0
      ? `<span class="text-xs text-fg-muted">+${moreCount} more</span>`
      : '';
    // CVE summary badge — critical/high are the actionable ones, shown first.
    const cveTotal = p.cveTotal || 0;
    let cveBadge = '';
    if (cveTotal > 0) {
      const parts = [];
      if (p.cveCritical > 0) parts.push(`${p.cveCritical} crit`);
      if (p.cveHigh > 0) parts.push(`${p.cveHigh} high`);
      const label = parts.length ? parts.join(' · ') : `${cveTotal} CVE${cveTotal === 1 ? '' : 's'}`;
      const cls = p.cveCritical > 0 ? 'bg-accent-bad/20 text-accent-bad'
                : p.cveHigh > 0 ? 'bg-accent-warn/20 text-accent-warn'
                : 'bg-neutral-700 text-neutral-300';
      cveBadge = `<span class="badge font-mono ${cls}"
        title="${cveTotal} known CVE${cveTotal === 1 ? '' : 's'} in this package version">${label}</span>`;
    }
    // Per-CVE chips (link to NVD), severity-colored, fixed-version in tooltip.
    const cveList = (p.cves && p.cves.length)
      ? `<div class="flex flex-wrap gap-1 mt-2">` +
        p.cves.slice(0, 12).map(v =>
          `<a href="https://nvd.nist.gov/vuln/detail/${escapeAttr(v.id)}" target="_blank" rel="noopener"
             class="text-xs font-mono px-1.5 py-0.5 rounded ${sevClass(v.severity)}"
             title="${escapeAttr(v.severity)}${v.fixed ? ' — fixed in ' + escapeAttr(v.fixed) : ''}">${escapeHtml(v.id)}</a>`
        ).join('') +
        (cveTotal > 12 ? `<span class="text-xs text-fg-muted self-center">+${cveTotal - 12} more</span>` : '') +
        `</div>`
      : '';
    return `
    <div class="card">
      <div class="flex flex-wrap items-baseline justify-between mb-2 gap-2">
        <div class="font-mono font-bold">
          ${escapeHtml(p.name)}
          <span class="ml-1 text-sm font-normal text-fg-muted">${escapeHtml(p.version || '')}</span>
        </div>
        <div class="flex items-center gap-2 text-xs text-fg-muted">
          ${cveBadge}
          <span class="font-mono uppercase">${escapeHtml(p.type || 'unknown')}</span>
          <span>·</span>
          <span>${p.imageCount} image${p.imageCount === 1 ? '' : 's'}</span>
        </div>
      </div>
      <div class="flex flex-wrap">${imagesPeek}${moreText}</div>
      ${cveList}
    </div>`;
  }).join('');
}

// Tailwind classes for a CVE severity chip.
function sevClass(sev) {
  switch ((sev || '').toUpperCase()) {
    case 'CRITICAL': return 'bg-accent-bad/20 text-accent-bad';
    case 'HIGH': return 'bg-accent-warn/20 text-accent-warn';
    case 'MEDIUM': return 'bg-yellow-900/30 text-yellow-300';
    case 'LOW': return 'bg-sky-900/30 text-sky-300';
    default: return 'bg-neutral-700 text-neutral-300';
  }
}

function escapeHtml(s) {
  const div = document.createElement('div');
  div.textContent = s;
  return div.innerHTML;
}

function escapeAttr(s) {
  return String(s).replace(/[^\w.-]/g, '');
}

function showError(msg) {
  document.getElementById('packages-container').innerHTML =
    `<div class="text-center py-12 text-accent-bad">${escapeHtml(msg)}</div>`;
}

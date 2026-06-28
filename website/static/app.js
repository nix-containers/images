let allImages = [];
let filteredImages = [];

document.addEventListener('DOMContentLoaded', () => {
  loadImages();
  document.getElementById('search').addEventListener('input', filter);
  document.getElementById('category-filter').addEventListener('change', filter);
});

async function loadImages() {
  try {
    const r = await fetch('/images-data.json');
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
}

function populateCategoryFilter() {
  const cats = [...new Set(allImages.map(i => i.category))].sort();
  const sel = document.getElementById('category-filter');
  cats.forEach(c => {
    const opt = document.createElement('option');
    opt.value = c;
    opt.textContent = c;
    sel.appendChild(opt);
  });
}

function filter() {
  const q = document.getElementById('search').value.toLowerCase();
  const cat = document.getElementById('category-filter').value;
  filteredImages = allImages.filter(i => {
    const matchesQ = !q ||
      i.name.toLowerCase().includes(q) ||
      (i.description || '').toLowerCase().includes(q);
    const matchesCat = !cat || i.category === cat;
    return matchesQ && matchesCat;
  });
  render();
}

function render() {
  const c = document.getElementById('images-container');
  if (filteredImages.length === 0) {
    c.innerHTML = `<div class="col-span-full text-center py-12 text-fg-muted">
      No images match your filters.
    </div>`;
    return;
  }
  c.innerHTML = filteredImages.map(i => `
    <a href="/images/${escapeAttr(i.name)}/"
       class="card block">
      <div class="flex items-center justify-between mb-2">
        <div class="font-mono font-bold text-fg-primary">${escapeHtml(i.name)}</div>
        <span class="badge-cat-${escapeAttr(i.categorySlug || 'unknown')}">${escapeHtml(i.category || 'unknown')}</span>
      </div>
      <p class="text-sm text-fg-muted line-clamp-2">${escapeHtml(i.description || '')}</p>
      <div class="mt-3 text-xs text-fg-muted font-mono">${escapeHtml(i.version || '')}</div>
    </a>
  `).join('');
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

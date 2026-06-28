#!/usr/bin/env python3
"""Static site renderer for nix-containers website.

Invoked from the Nix buildPhase. Reads:
  - images-data.json (produced by Nix from images/*/default.nix + README)
  - templates/{index,image-page}.html
Writes:
  - <out>/index.html
  - <out>/images/<name>/index.html (one per image)
  - <out>/images-data.json (slim version, no full README HTML)
"""
import argparse
import json
import os
import subprocess
import sys
import datetime
from pathlib import Path


def category_slug(category: str) -> str:
    """Map a category string to a CSS class slug."""
    if not category:
        return "unknown"
    s = category.lower().replace(" ", "-").replace("_", "-")
    allowed = {"runtime", "build-env", "database", "web-service",
               "devops-tool", "utility", "shell"}
    return s if s in allowed else "unknown"


def render_markdown(md_text: str, cmark_bin: str) -> str:
    """Convert markdown to HTML using cmark."""
    if not md_text or not md_text.strip():
        return "<p class='text-fg-muted italic'>No README available.</p>"
    p = subprocess.run([cmark_bin, "--unsafe"],
                       input=md_text, capture_output=True, text=True, check=True)
    return p.stdout


def render_nix(nix_text: str, pygmentize_bin: str) -> str:
    """Syntax-highlight a Nix file with pygments."""
    if not nix_text:
        return ""
    p = subprocess.run(
        [pygmentize_bin, "-l", "nix", "-f", "html",
         "-O", "style=monokai,noclasses=False,cssclass=highlight,wrapcode=True"],
        input=nix_text, capture_output=True, text=True, check=True)
    return p.stdout


def fill_template(template: str, mapping: dict) -> str:
    """Mustache-style substitution. {{KEY}} -> mapping[KEY]. Raises if any
    placeholder is left unfilled — better to catch typos at build time."""
    result = template
    for key, value in mapping.items():
        result = result.replace("{{" + key + "}}", str(value))
    import re
    leftover = re.findall(r"\{\{([A-Z_]+)\}\}", result)
    if leftover:
        raise KeyError(f"Unfilled template placeholders: {leftover}")
    return result


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", required=True, help="Path to images-data.json")
    ap.add_argument("--templates", required=True, help="Path to templates/ directory")
    ap.add_argument("--out", required=True, help="Output directory (will be created)")
    ap.add_argument("--cmark", required=True, help="Path to cmark binary")
    ap.add_argument("--pygmentize", required=True, help="Path to pygmentize binary")
    args = ap.parse_args()

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    (out / "images").mkdir(exist_ok=True)

    with open(args.data) as f:
        data = json.load(f)

    image_template = Path(args.templates, "image-page.html").read_text()
    index_template = Path(args.templates, "index.html").read_text()

    build_time = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")

    slim_images = []
    for img in data["images"]:
        name = img["name"]
        readme_html = render_markdown(img.get("readme", ""), args.cmark)
        nix_html = render_nix(img.get("nixCode", ""), args.pygmentize)
        mapping = {
            "NAME": name,
            "DESCRIPTION": img.get("description", ""),
            "CATEGORY": img.get("category", "unknown"),
            "CATEGORY_SLUG": category_slug(img.get("category", "")),
            "VERSION": img.get("version", "latest"),
            "PULL_COMMAND": img.get("pullCommand", f"docker pull ghcr.io/nix-containers/images/{name}:latest"),
            "README_HTML": readme_html,
            "NIX_HTML": nix_html,
            "BUILD_TIME": build_time,
        }
        page_html = fill_template(image_template, mapping)
        page_dir = out / "images" / name
        page_dir.mkdir(parents=True, exist_ok=True)
        (page_dir / "index.html").write_text(page_html)

        slim_images.append({
            "name": name,
            "description": img.get("description", ""),
            "category": img.get("category", "unknown"),
            "categorySlug": category_slug(img.get("category", "")),
            "version": img.get("version", "latest"),
            "hasTest": img.get("hasTest", False),
            "pullCommand": img.get("pullCommand", ""),
        })

    slim_data = {
        "totalCount": len(slim_images),
        "images": slim_images,
        "lastUpdated": build_time,
    }
    (out / "images-data.json").write_text(json.dumps(slim_data))

    rendered_index = index_template  # No global placeholders to fill today
    (out / "index.html").write_text(rendered_index)

    print(f"Rendered {len(slim_images)} per-image pages + index -> {out}",
          file=sys.stderr)


if __name__ == "__main__":
    main()

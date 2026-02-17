"""Fetch brand assets and generate QR code for Quarto poster.

Runs as a Quarto pre-render script:
  1. Downloads remote assets (logos) with ETag/Last-Modified caching.
     Falls back to cached copies when offline.
  2. Reads `footer-url` from poster.qmd YAML front matter and generates
     a QR code SVG at figures/qr.svg.

Configure ASSETS below: map local destination paths to raw GitHub URLs.
"""

import hashlib
import io
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

import segno

# ---------------------------------------------------------------------------
# Configuration — add assets here
# ---------------------------------------------------------------------------
ASSETS = {
    # "local/path": "https://raw.githubusercontent.com/org/repo/main/file"
    "figures/logo-lab.svg": "https://raw.githubusercontent.com/krantzlab/figures/dist/web/navbar-logo-krantzlab.svg",
    "figures/logo-university.svg": "https://raw.githubusercontent.com/krantzlab/figures/dist/web/logo-vumc.svg"
}

CACHE_DIR = Path(".asset-cache")


def _meta_path(dest: str) -> Path:
    """Return path to the JSON metadata sidecar for a given asset."""
    key = hashlib.sha256(dest.encode()).hexdigest()[:12]
    return CACHE_DIR / f"{key}.json"


def _read_meta(dest: str) -> dict:
    path = _meta_path(dest)
    if path.exists():
        return json.loads(path.read_text())
    return {}


def _write_meta(dest: str, meta: dict) -> None:
    CACHE_DIR.mkdir(exist_ok=True)
    _meta_path(dest).write_text(json.dumps(meta))


def fetch(dest: str, url: str) -> None:
    dest_path = Path(dest)
    meta = _read_meta(dest)

    # Build conditional request headers
    req = urllib.request.Request(url)
    if dest_path.exists():
        if meta.get("etag"):
            req.add_header("If-None-Match", meta["etag"])
        if meta.get("last_modified"):
            req.add_header("If-Modified-Since", meta["last_modified"])

    try:
        resp = urllib.request.urlopen(req, timeout=10)
    except urllib.error.HTTPError as e:
        if e.code == 304:
            print(f"  {dest} — up to date (304)")
            return
        if dest_path.exists():
            print(f"  {dest} — remote error ({e.code}), using cached copy")
            return
        print(f"  {dest} — remote error ({e.code}) and no cached copy", file=sys.stderr)
        return
    except (urllib.error.URLError, OSError):
        if dest_path.exists():
            print(f"  {dest} — offline, using cached copy")
        else:
            print(f"  {dest} — MISSING and offline, cannot fetch", file=sys.stderr)
        return

    # Write the file
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    dest_path.write_bytes(resp.read())

    # Save caching metadata
    headers = resp.headers
    _write_meta(dest, {
        "etag": headers.get("ETag"),
        "last_modified": headers.get("Last-Modified"),
    })
    print(f"  {dest} — downloaded")


QR_DEST = Path("figures/qr.svg")
QR_SOURCE = Path("poster.qmd")


def _read_footer_url(qmd_path: Path) -> str | None:
    """Extract footer-url from YAML front matter."""
    text = qmd_path.read_text()
    # Match YAML block between --- delimiters
    m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not m:
        return None
    for line in m.group(1).splitlines():
        # Match uncommented footer-url line
        stripped = line.strip()
        if stripped.startswith("#"):
            continue
        if stripped.startswith("footer-url:"):
            value = stripped.split(":", 1)[1].strip().strip("\"'")
            return value if value else None
    return None


def generate_qr(qmd_path: Path = QR_SOURCE, dest: Path = QR_DEST) -> None:
    """Generate a QR code SVG from the footer-url in the YAML front matter."""
    url = _read_footer_url(qmd_path)
    if url is None:
        print("  qr — no footer-url set, skipping")
        return

    qr = segno.make(url, error="L")
    buf = io.BytesIO()
    qr.save(buf, kind="svg", scale=10, border=0, dark="#2a2a2a", light=None)

    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(buf.getvalue())
    print(f"  {dest} — generated for {url}")


def main() -> None:
    print("fetch-assets: checking remote assets...")
    for dest, url in ASSETS.items():
        fetch(dest, url)

    print("fetch-assets: generating QR code...")
    generate_qr()

    print("fetch-assets: done")


if __name__ == "__main__":
    main()

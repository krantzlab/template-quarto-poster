# Quarto + Typst Scientific Poster Template

A GitHub template repository for creating reproducible scientific conference posters using [Quarto](https://quarto.org/) and [Typst](https://typst.app/).

## Why Quarto + Typst?

- **Reproducible**: figures are generated from code (Python, R, Julia) and embedded automatically
- **Fast**: Typst renders PDFs in milliseconds, not minutes like LaTeX
- **Simple**: write in Markdown, configure in YAML — no LaTeX knowledge needed
- **Version-controllable**: everything is plain text

## Prerequisites

- [Miniforge](https://github.com/conda-forge/miniforge) (provides `mamba`)

Everything else (Quarto, Python, Jupyter, plotting libraries) is installed into a project-specific environment via `environment.yml`.

> **Note:** Since Quarto is installed inside the conda environment, you should launch Positron from a terminal with the environment activated so it can find Quarto:
> ```bash
> mamba activate poster
> positron .
> ```

## Quick Start

1. Click **"Use this template"** on GitHub to create your own repo, then clone it.

2. Create and activate the environment:

   ```bash
   mamba env create -f environment.yml
   mamba activate poster
   ```

3. Install the Quarto poster extension:

   ```bash
   quarto add quarto-ext/typst-templates/poster
   ```

   Confirm when prompted. This creates an `_extensions/` folder.

4. Edit `poster.qmd` — update the title, authors, content, and figures.

5. Render the poster to PDF:

   ```bash
   quarto render poster.qmd
   ```

   Or use live preview (re-renders on save):

   ```bash
   quarto preview poster.qmd
   ```

## Project Structure

```
.
├── _quarto.yml         # Quarto project config (pre-render hook)
├── environment.yml     # Mamba/conda environment specification
├── fetch-assets.py     # Pre-render script: fetches logos + generates QR code
├── poster.qmd          # Main poster source file
├── references.bib      # Bibliography (BibTeX)
├── figures/             # Static images (plots, diagrams, logos)
├── .gitignore
├── LICENSE
└── README.md
```

## Pre-render Script

`fetch-assets.py` runs automatically before every `quarto render` (configured in `_quarto.yml`). It handles two things:

### Remote Logos

Logos are fetched from a central brand-assets repo so there is a single source of truth. Edit the `ASSETS` dict in `fetch-assets.py` to map local file paths to raw GitHub URLs:

```python
ASSETS = {
    "figures/logo-lab.svg": "https://raw.githubusercontent.com/org/repo/main/logo.svg",
    "figures/logo-university.svg": "https://raw.githubusercontent.com/org/repo/main/uni-logo.svg",
}
```

The script uses HTTP conditional requests (ETag / Last-Modified) to skip re-downloads when the remote file hasn't changed. If the network is unavailable, cached copies are used silently.

### QR Code Generation

If `footer-url` is set in the YAML header of `poster.qmd`, the script generates a QR code SVG at `figures/qr.svg` automatically. No manual QR creation needed — just set your URL:

```yaml
footer-url: "https://example.com"
footer-qr: "figures/qr.svg"
```

Comment out `footer-url` to skip QR generation.

## Configuration

All poster settings live in the YAML header of `poster.qmd`:

| Option                    | Description                          | Example                  |
|---------------------------|--------------------------------------|--------------------------|
| `size`                    | Poster dimensions (inches, WxH)      | `"36x24"`, `"48x36"`    |
| `poster-authors`          | Author names                         | `"A. Smith, B. Jones"`   |
| `departments`             | Institution / department             | `"Univ. of Example"`     |
| `institution-logo`        | Path to left logo image              | `"figures/logo.svg"`     |
| `institution-logo-2`      | Path to right logo image             | `"figures/logo2.svg"`    |
| `footer-text`             | Footer text (conference, date, etc.) | `"ICML 2026"`            |
| `footer-url`              | URL shown under header logo (also generates QR) | `"https://example.com"` |
| `footer-url-2`            | URL shown under footer logo          | `"https://example.org"` |
| `footer-emails`           | Author emails in footer              | `"a@uni.edu"`            |
| `footer-qr`               | Path to QR code image                | `"figures/qr.svg"`       |
| `footer-qr-text`          | Description text next to QR code     | `"Scan for abstract"`   |
| `footer-acknowledgements` | Funding / acknowledgements           | `"Supported by ..."`     |

### Common poster sizes

| Name               | Size           | Use case                   |
|--------------------|----------------|----------------------------|
| US Landscape       | `"36x24"`      | Standard US conference     |
| US Large Landscape | `"48x36"`      | Large US conference        |
| A0 Portrait        | `"33.1x46.8"` | European conference (A0)   |
| A1 Portrait        | `"23.4x33.1"` | Smaller European format    |

### Adding a bibliography

1. Add your references to `references.bib`.
2. Uncomment the `bibliography` and `bibliographystyle` lines in the YAML header of `poster.qmd`.
3. Cite with `[@key]` in the text and add a `# References` section at the end.

### Adding Python packages

Add packages to `environment.yml` and update the environment:

```bash
mamba env update -f environment.yml --prune
```

## Customizing the Typst Template

The extension installs Typst template files under `_extensions/`. You can modify these to change colors, layout, fonts, header/footer styling, etc. See the [Typst documentation](https://typst.app/docs/) and [Quarto Custom Typst Formats](https://quarto.org/docs/output-formats/typst-custom.html) for details.

## Resources

- [Quarto Typst Basics](https://quarto.org/docs/output-formats/typst.html)
- [Quarto Typst Poster Extension](https://github.com/quarto-ext/typst-templates/tree/main/poster)
- [Quarto Virtual Environments Guide](https://quarto.org/docs/projects/virtual-environments.html)
- [Typst Documentation](https://typst.app/docs/)

## License

This template is released under the [MIT License](LICENSE). Use it for any poster you like.

---

Built with the help of [Claude Code](https://claude.com/claude-code).

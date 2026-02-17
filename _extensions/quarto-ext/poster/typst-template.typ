// Billboard-style scientific poster — Quarto + Typst
// One big idea. One killer figure. Everything else whispers.

// ---------------------------------------------------------------------------
// Hero text — the finding people read from 20 feet away
// ---------------------------------------------------------------------------
#let hero(body) = {
  block(
    width: 100%,
    above: 0pt,
    below: 0pt,
    inset: (y: 16pt),
    {
      set text(size: 80pt, weight: "medium", fill: rgb("1a1a1a"))
      set par(leading: 0.82em, justify: false)
      body
    },
  )
}

// ---------------------------------------------------------------------------
// Section label — whisper-quiet, not a heading
// ---------------------------------------------------------------------------
#let section-label(body) = {
  block(above: 10pt, below: 14pt,
    text(
      size: 36pt,
      weight: "semibold",
      fill: rgb("888888"),
      tracking: 0.12em,
      upper(body),
    ),
  )
}

// ---------------------------------------------------------------------------
// Main poster function
// ---------------------------------------------------------------------------
#let poster(
  size: "48x36",
  title: "Paper Title",
  authors: "Author Names",
  departments: "Department Name",
  univ_logo: none,
  univ_logo_2: none,
  footer_text: none,
  footer_url: none,
  footer_url_2: none,
  footer_email_ids: none,
  footer_color: "2a2a2a",
  accent_color: "2a2a2a",
  footer_acknowledgements: none,
  footer_qr: none,
  footer_qr_text: none,
  body,
) = {
  // --- Dimensions ---
  let sizes = size.split("x")
  let width = int(sizes.at(0)) * 1in
  let height = int(sizes.at(1)) * 1in

  // --- Colours ---
  let header_footer_bg = rgb("E5EEF6")
  let page_bg = rgb("f8f9fa")

  // --- Typography ---
  set text(
    font: ("Helvetica Neue", "Helvetica", "Arial"),
    size: 40pt,
    fill: rgb("2a2a2a"),
  )

  // --- Page ---
  set page(
    width: width,
    height: height,
    fill: page_bg,
    margin: (top: 4.5in, left: 2.5in, right: 2.5in, bottom: 3.7in),

    // Header and footer background bands
    background: {
      place(top, rect(width: 100%, height: 4in, fill: header_footer_bg))
      place(bottom, rect(width: 100%, height: 3.2in, fill: header_footer_bg))
    },

    // Header: logo-left, title-right
    header: {
      v(1in)
      {
        let title_block = {
          text(size: 96pt, weight: "bold", fill: rgb("1a1a1a"), title)
          linebreak()
          v(10pt)
          text(size: 32pt, fill: rgb("666666"), {
            authors
            h(16pt)
            sym.dot.c
            h(16pt)
            departments
          })
        }

        if univ_logo != none {
          grid(
            columns: (auto, 1fr),
            column-gutter: 40pt,
            align: horizon,
            {
              image(univ_logo, height: 2.6in)
              if footer_url != none {
                v(6pt)
                align(center, text(font: ("Courier New", "Courier"), size: 22pt, fill: rgb("777777"), footer_url))
              }
            },
            title_block,
          )
        } else {
          align(center, title_block)
        }
      }
    },

    // Footer: QR left, funding center, lab logo + contact right
    footer: {
      set text(size: 28pt, fill: rgb("555555"))
      pad(top: 0.5in, bottom: 0.5in, {
        grid(
          columns: (auto, 1fr, auto),
          column-gutter: 40pt,
          align: horizon,

          // Left: QR code + description
          {
            if footer_qr != none {
              stack(dir: ltr, spacing: 20pt,
                image(footer_qr, height: 1.5in),
                if footer_qr_text != none {
                  align(horizon, text(size: 26pt, fill: rgb("777777"), footer_qr_text))
                },
              )
            }
          },

          // Center: conference + funding
          align(center, {
            if footer_text != none {
              text(size: 32pt, weight: "semibold", footer_text)
              linebreak()
              v(10pt)
            }
            if footer_acknowledgements != none {
              text(size: 24pt, fill: rgb("777777"), footer_acknowledgements)
            }
          }),

          // Right: lab logo + contact
          align(right, {
            if univ_logo_2 != none {
              image(univ_logo_2, width: 4in)
              v(10pt)
            }
            if footer_url_2 != none {
              text(font: ("Courier New", "Courier"), size: 24pt, footer_url_2)
              linebreak()
              v(6pt)
            }
            if footer_email_ids != none {
              text(font: ("Courier New", "Courier"), size: 24pt, footer_email_ids)
            }
          }),
        )
      })
    },
  )

  // --- Headings become quiet labels if used ---
  set heading(numbering: none)
  show heading.where(level: 1): it => {
    block(above: 32pt, below: 14pt,
      text(size: 36pt, weight: "semibold", fill: rgb("888888"), tracking: 0.12em, upper(it.body)),
    )
  }
  show heading.where(level: 2): it => {
    block(above: 24pt, below: 12pt,
      text(size: 32pt, weight: "semibold", fill: rgb("999999"), tracking: 0.1em, upper(it.body)),
    )
  }

  // --- Equations ---
  set math.equation(numbering: none)

  // --- Lists — minimal bullet ---
  set list(indent: 0pt, body-indent: 18pt, marker: text(fill: rgb("bbbbbb"))[#sym.bullet])

  // --- Paragraphs ---
  set par(justify: false, first-line-indent: 0em, spacing: 0.65em)

  // --- Body ---
  body
}

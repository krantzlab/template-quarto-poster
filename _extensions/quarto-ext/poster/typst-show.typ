// Show rule — forwards Quarto YAML metadata to the poster() function.

#show: doc => poster(
  $if(title)$ title: [$title$], $endif$
  $if(poster-authors)$ authors: [$poster-authors$], $endif$
  $if(departments)$ departments: [$departments$], $endif$
  $if(size)$ size: "$size$", $endif$
  $if(institution-logo)$ univ_logo: "$institution-logo$", $endif$
  $if(institution-logo-2)$ univ_logo_2: "$institution-logo-2$", $endif$
  $if(footer-text)$ footer_text: [$footer-text$], $endif$
  $if(footer-url)$ footer_url: [$footer-url$], $endif$
  $if(footer-url-2)$ footer_url_2: [$footer-url-2$], $endif$
  $if(footer-emails)$ footer_email_ids: [$footer-emails$], $endif$
  $if(footer-color)$ footer_color: "$footer-color$", $endif$
  $if(accent-color)$ accent_color: "$accent-color$", $endif$
  $if(footer-acknowledgements)$ footer_acknowledgements: [$footer-acknowledgements$], $endif$
  $if(footer-qr)$ footer_qr: "$footer-qr$", $endif$
  $if(footer-qr-text)$ footer_qr_text: [$footer-qr-text$], $endif$
  doc,
)

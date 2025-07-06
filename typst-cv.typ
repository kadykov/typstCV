$-- ========================================================================== --
$-- WARNING: PANDOC TEMPLATE - NOT PURE TYPST                                  --
$-- ========================================================================== --
$-- This file uses Pandoc's templating syntax (e.g., $variable$, $if(...)$).   --
$-- It will NOT pass Typst linting or compilation directly.                    --
$-- Pandoc processes this template *before* passing the result to Typst.       --
$-- Ignore Typst linter errors related to Pandoc syntax in this file.          --
$-- ========================================================================== --

// Import the local package and specific functions/variables needed
#import "@local/pandoc-cv:0.1.0": setup-style, horizontalrule, bodywidth, full-width, body-side, company-location, event-date, profile-photo, hidden-heading

// Construct datetime object from structured date if provided via YAML map, else use today
// TODO: Move date logic into style.typ (see user feedback)
#let date-object = $if(date.year)$datetime(year: $date.year$, month: $date.month$, day: $date.day$)$else$datetime.today()$endif$

// Call the setup function from the imported package using original conditional logic
#show: setup-style.with(
  $if(title)$title: "$title$", $endif$
  $if(author)$author: "$author$", $endif$
  $if(email)$email: "$email$".replace("\\", ""), $endif$
  $if(github)$github: "$github$", $endif$
  $if(gitlab)$gitlab: "$gitlab$", $endif$
  $if(linkedin)$linkedin: "$linkedin$", $endif$
  $if(website)$website: "$website$", $endif$
  date: date-object, // Always present
  $if(keywords)$keywords: ($for(keywords)$ "$keywords$", $endfor$), $endif$
  hyphenate: $if(hyphenate)$$hyphenate$$else$auto$endif$ // Use original logic
)

#block(width: bodywidth)[

  $body$

]

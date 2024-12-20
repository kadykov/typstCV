#import "@preview/fontawesome:0.5.0": *

#let author = "Aleksandr KADYKOV"

#let text-color = black
#let background-color = luma(100%, 0%) // Transparent white
#let primary-color = rgb("#3A468C")
// To avoid messing up with contexts
// #let layoutwidth = layout(size => {return size.width})
// #layoutwidth
#let full-width = 453.45pt
#let bodywidth = 317.41pt
#let line-spacing = 0.8em
// Define a function to set up style that accepts external variables
#let setup-style(
  author: author,
  public-email: "cv@kadykov.com",
  title: "Research Engineer",
  website: "www.kadykov.com",
  github: "kadykov",
  gitlab: "kadykov",
  linkedin: "aleksandr-kadykov",
  keywords: ("CV",),
  language: "en",
  date: auto,
  hyphenate: auto,
  doc,
) = {

  // Document settings
  set text(
    font: "IBM Plex Serif",
    size: 10.5pt,
    lang: language,
    fill: text-color,
    hyphenate: hyphenate,
  )

  show heading: set text(
    fill: primary-color,
    font: "Fira Sans",
    weight: "medium",
    size: 1.1em,
    hyphenate: auto,
  )

  show strong: set text(font: "IBM Plex Serif SmBld")

  set document(
    title: title,
    author: author,
    date: date,
    keywords: keywords,
  )

  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3.0cm),
    header: [
      #author
      #h(1fr)
      #if "PHONE" in sys.inputs.keys() [
        #link("tel:" + sys.inputs.PHONE.replace(regex("[^0-9+]"), ""))[
          #text(fill: primary-color)[#fa-phone()]
          #sys.inputs.PHONE.replace("_", " ")
        ]
        |
      ]
      #let email = {
        if "EMAIL" in sys.inputs.keys() {
          sys.inputs.EMAIL
        } else {
          public-email
        }
      }
      #link("mailto:" + email)[
        #text(fill: primary-color)[#fa-envelope()]
        #email
      ]
      #v(-0.5em)
      #line(length: 100%, stroke: 0.5pt)
      #v(-1em)
    ],
    footer: [
      #v(-1em)
      #line(length: 100%, stroke: 0.5pt)
      #v(-0.5em)
      #text(fill: primary-color)[#fa-arrow-up-right-from-square()]
      #link("https://" + website)[#website]
      #h(1fr)
      #text(fill: black)[#fa-github()]
      #link("https://github.com/" + github)[#github] |
      #text(fill: orange)[#fa-gitlab()]
      #link("https://gitlab.com/" + gitlab)[#gitlab] |
      #text(fill: blue)[#fa-linkedin()]
      #link("https://www.linkedin.com/in/" + linkedin)[#linkedin]
    ],
  )

  // Paragraph settings
  set par(
    justify: false,
    leading: line-spacing,
  )

  doc
}

// Custom macros
#let horizontalrule = context {
  let current-position = here().position().y
  if current-position > 100pt and current-position < 730pt [
    #line(length: full-width, stroke: 1.5pt + primary-color)
  ]
}

#let hidden-heading(title) = (
  context {
    let heading-size = measure(title)
    [
      #show heading: set text(fill: background-color)
      #v(-1.5 * heading-size.height)
      #title
      #v(-heading-size.height)
    ]
  }
)

#let body-side(body, side: []) = (
  context {
    let body-after-text = measure(block()[Text \ #body], width: bodywidth)
    let text-only = measure([Text])
    [
      #body
      #box()[
        #place(
          right,
          dy: -(body-after-text.height - text-only.height),
          dx: full-width,
        )[#side]
      ]
      #h(-0.25em)
    ]
  }
)

#let company-location(body) = [
  #text(fill: primary-color)[#fa-location-dot()]
  #emph(body)
]

#let event-date(body) = [
  #text(fill: primary-color)[#fa-calendar()]
  #emph(body)
]

#let profile-photo(photo) = [
  #box(
    clip: true,
    stroke: 1.5pt + primary-color,
    radius: (
      bottom-left: 0pt,
      bottom-right: 50%,
      top-left: 50%,
      top-right: 0pt,
    ),
  )[#photo]
]

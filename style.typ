#import "@preview/fontawesome:0.5.0": *

#let name = "Aleksandr KADYKOV"

#let text-color = black
#let background-color = luma(100%, 0%) // Transparent white
#let primary-color = rgb("#3A468C")
#let bodywidth = 70%
// Define a function to set up style that accepts external variables
#let setup-style(
  name: name,
  email: "cv@kadykov.com",
  post-name: "Research Engineer",
  website: "www.kadykov.com",
  github: "kadykov",
  gitlab: "kadykov",
  linkedin: "aleksandr-kadykov",
  keywords: ("CV",),
  language: "en",
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
    title: post-name,
    author: name,
    date: auto,
    keywords: keywords,
  )

  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3.0cm),
    header: [
      #name
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
          "cv@kadykov.com"
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
  set par(justify: false, leading: 0.8em)

  doc
}
// Custom macros
#let secline() = {
  v(-0.3em)
  line(length: 100%, stroke: 1.5pt + primary-color)
  v(-0.1em)
}

#let experience(
  company-title: [Best Company, Inc],
  company-subtitle: [The best company in the world],
  company-location: [City, \ Country],
  dates: [Jan 1970 \ present],
  description,
) = [
  #box()[
    #context {
      let current-position = here().position().y
      if current-position > 100pt [#secline()]
    }
    #block(width: 100%)[
      #block(width: bodywidth + 5%)[
        == #company-title
        #emph()[#company-subtitle]
      ]
      #place(top + right)[
        #text(fill: primary-color)[#fa-location-dot()]
        #emph()[#company-location]
      ]
    ]
  ]
  #block(width: 100%)[
    #place(top + right)[
      #text(fill: primary-color)[#fa-calendar()]
      #emph()[#dates]
    ]
    #block(width: bodywidth)[
      #description
    ]
  ]
]

#let hidden-section(title) = [
  #heading()[
    #v(-1.15em)
    #text(fill: background-color)[#title]
    #v(-0.5em)
  ]
]

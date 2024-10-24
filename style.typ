#import "@preview/fontawesome:0.4.0": *

#let text-color = black
#let background-color = white
#let primary-color = rgb("#4457af")
#let bodywidth = 73%
// Define a function to set up style that accepts external variables
#let setup-style(
  name: "Aleksandr Kadykov",
  email: "cv@kadykov.com",
  post-name: "Research Engineer",
  website: "www.kadykov.com",
  github: "kadykov",
  gitlab: "kadykov",
  linkedin: "aleksandr-kadykov",
  doc
) = {

  // Document settings
  set text(
    font: "IBM Plex Serif Text",
    size: 10.5pt,
    lang: "en",
    fill: text-color,
    hyphenate: true,
  )

  show heading: set text(
    fill: primary-color,
    font: "Fira Sans",
    weight: "medium",
    size: 1.1em,
    hyphenate: false,
  )

  show strong: set text(
    font: "IBM Plex Serif SmBld"
  )

  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3.5cm),
    header: [
      #name
      #h(1fr)
      #if "PHONE" in sys.inputs.keys() [
        #link("tel:" + sys.inputs.PHONE.replace(regex("[^0-9+]"), ""))[
          #fa-phone()
          #sys.inputs.PHONE.replace("_", " ")
        ]
        |
      ]
      #link("mailto:" + email)[
        #fa-envelope()
        #email
      ]
      #v(-0.5em)
      #line(length: 100%, stroke: 0.5pt)
      #v(-0.5em)
    ],
    footer: [
      #v(-0.5em)
      #line(length: 100%, stroke: 0.5pt)
      #v(-0.5em)
      #fa-arrow-up-right-from-square()
      #link("https://" + website)[#website]
      #h(1fr)
      #text(fill: black)[#fa-github()]
      #link("https://github.com/" + github)[#github] |
      #text(fill: orange)[#fa-gitlab()]
      #link("https://gitlab.com/" + gitlab)[#gitlab] |
      #text(fill: blue)[#fa-linkedin()]
      #link("https://www.linkedin.com/in/" + linkedin)[#linkedin]
    ]
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

#let experience(company-title: str, company-subtitle: str, company-location: str, dates: str, description) = [
  #box()[
    #secline()
    #block(width: 100%)[
      #block(width: bodywidth)[
        == #company-title
        #emph()[#company-subtitle]
      ]
      #place(top + right)[
        #fa-location-dot()
        #emph()[#company-location]
      ]
    ]
  ]
  #block(width: 100%)[
    #place(top + right)[
      #fa-calendar()
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

#import "style.typ": *

#let today = datetime.today()
#let suffix = {
  let day = today.day()
  if day == 1 or day == 21 or day == 31 { "st" }
  else if day == 2 or day == 22 { "nd" }
  else if day == 3 or day == 23 { "rd" }
  else { "th" }
}

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with()

#let from-content = [
  Mons,
  Belgium

  #today.display(
    "[month repr:long] [day padding:none]"
  )#super(suffix),
  #today.year()
]

#let to-content = [
  // Future Employer

  // Company

  // Street 123\
  // City\
  // 00000 \
  // Country
]

#context {
  let intro-height = calc.max(
    measure(from-content).height,
    measure(to-content).height,
  )

  box(height: intro-height)[#from-content]
  h(1fr)
  box(height: intro-height, width: bodywidth)[#to-content]
}

#v(1em)

#align(right)[
  #block(width: bodywidth)[
    #set align(left)
    Dear Future Employer,

    #lorem(20)

    #lorem(50)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    #lorem(30)

    Best regards,\
    #name
  ]
]

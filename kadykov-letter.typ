#import "style.typ": *

#let name = "Aleksandr Kadykov"
#let post-name = "Research Engineer"
#let website = "www.kadykov.com"
#let github = "kadykov"
#let gitlab = "kadykov"
#let linkedin = "aleksandr-kadykov"

// Optional email input
#let email = {
  if "EMAIL" in sys.inputs.keys() {sys.inputs.EMAIL}
  else {"cv@kadykov.com"}
}

#let today = datetime.today()
#let suffix = {
  let day = today.day()
  if day == 1 or day == 21 or day == 31 { "st" }
  else if day == 2 or day == 22 { "nd" }
  else if day == 3 or day == 23 { "rd" }
  else { "th" }
}

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with(
  name: name,
  email: email,
  website: website,
  github: github,
  gitlab: gitlab,
  linkedin: linkedin,
)


#let from-content = [
  *From*:

  #name

  Mons,
  Belgium

  #today.display(
    "[month repr:long] [day]"
  )#super(suffix) \
  #today.year()
]

#let to-content = [
  *To*:

  Future Employer

  Company

  Street 123\
  City\
  00000 \
  Country
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
    *Subject*:
    Explainig my interest
    in working in your company

    #v(1em)

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

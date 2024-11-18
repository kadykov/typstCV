#import "@local/pandoc-cv:0.1.0": *

#let date = $if(date)$$date$$else$datetime.today()$endif$
#let suffix = {
  let day = date.day()
  if day == 1 or day == 21 or day == 31 {
    "st"
  } else if day == 2 or day == 22 {
    "nd"
  } else if day == 3 or day == 23 {
    "rd"
  } else {
    "th"
  }
}

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with(
  $if(title)$title: "$title$",$endif$
  $if(author)$author: "$author$",$endif$
  $if(public-email)$public-email: "$public-email$".replace("\\", ""),$endif$
  $if(github)$github: "$github$",$endif$
  $if(gitlab)$gitlab: "$gitlab$",$endif$
  $if(linkedin)$linkedin: "$linkedin$",$endif$
  $if(website)$website: "$website$",$endif$
  $if(date)$date: $date$,$endif$
  $if(keywords)$keywords: (
    $for(keywords)$
      "$keywords$",
    $endfor$
  ),
  $endif$
  hyphenate: true,
)

#let from-content = [
  $if(from)$$from$$endif$

  #date.display(
    "[month repr:long] [day padding:none]"
  )#super(suffix),
  #date.year()
]

#let to-content = [$if(to)$$to$$endif$]

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

    $body$
    #author
  ]
]

#import "@local/pandoc-cv:0.1.0": *

// Construct datetime object from structured date if provided via YAML map, else use today
#let date-object = $if(date.year)$datetime(year: $date.year$, month: $date.month$, day: $date.day$)$else$datetime.today()$endif$

#let suffix = {
  let day = date-object.day() // Use date-object
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
  $if(title)$title: "$title$", $endif$ // Comma after if present
  $if(author)$author: "$author$", $endif$ // Comma after if present
  $if(email)$email: "$email$".replace("\\", ""), $endif$ // Comma after if present
  $if(github)$github: "$github$", $endif$ // Comma after if present
  $if(gitlab)$gitlab: "$gitlab$", $endif$ // Comma after if present
  $if(linkedin)$linkedin: "$linkedin$", $endif$ // Comma after if present
  $if(website)$website: "$website$", $endif$ // Comma after if present
  date: date-object, // Use the constructed date-object, comma needed before next potential arg
  $if(keywords)$keywords: ($for(keywords)$ "$keywords$", $endfor$), $endif$ // Comma after if present
  hyphenate: true // Last argument, no trailing comma
)

#let from-content = [
  $if(from)$$from$$endif$

  #date-object.display( // Use date-object
    "[month repr:long] [day padding:none]"
  )#super(suffix),
  #date-object.year() // Use date-object
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

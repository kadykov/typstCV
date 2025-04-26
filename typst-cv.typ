#import "style.typ" // Import the style module

// Construct datetime object from structured date if provided via YAML map, else use today
#let date-object = $if(date.year)$datetime(year: $date.year$, month: $date.month$, day: $date.day$)$else$datetime.today()$endif$

// Call the function from `style.typ` and pass variables to set up the document style
#show: style.setup-style.with(
  $if(title)$title: "$title$", $endif$ // Comma after if present
  $if(author)$author: "$author$", $endif$ // Comma after if present
  $if(email)$email: "$email$".replace("\\", ""), $endif$ // Comma after if present
  $if(github)$github: "$github$", $endif$ // Comma after if present
  $if(gitlab)$gitlab: "$gitlab$", $endif$ // Comma after if present
  $if(linkedin)$linkedin: "$linkedin$", $endif$ // Comma after if present
  $if(website)$website: "$website$", $endif$ // Comma after if present
  date: date-object, // Always present, comma needed before next potential arg
  $if(keywords)$keywords: ($for(keywords)$ "$keywords$", $endfor$), $endif$ // Comma after if present
  hyphenate: auto // Last argument, no trailing comma
)

#block(width: style.bodywidth)[

  $body$

]

// #import "style.typ": *
#import "@local/pandoc-cv:0.1.0": *

#let date = $if(date)$datetime($date$)$else$datetime.today()$endif$

// Call the function from `style.typ` and pass variables to set up the document style
#show: setup-style.with(
  $if(title)$title: "$title$",$endif$
  $if(author)$author: "$author$",$endif$
  $if(public-email)$public-email: "$public-email$".replace("\\", ""),$endif$
  $if(github)$github: "$github$",$endif$
  $if(gitlab)$gitlab: "$gitlab$",$endif$
  $if(linkedin)$linkedin: "$linkedin$",$endif$
  $if(website)$website: "$website$",$endif$
  $if(date)$date: date,$endif$
  $if(keywords)$keywords: (
    $for(keywords)$
      "$keywords$",
    $endfor$
  ),
  $endif$
  hyphenate: auto,
)

#block(width: bodywidth)[

  $body$

]

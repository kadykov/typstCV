---
title: Typst CV Filter Test - Current Logic
---

# Name {photo="photo.png" photowidth="100pt"}
<name>
This header has a photo attribute.

## Section 1 {.hidden}

This header has the hidden class.

### Company {location="City \\ Country"}

This header has a location attribute.

#### Position {date="2023 - Present"}

This header has a date attribute.

##### Unchanged Header

This header has no special attributes or classes.

###### Header With Both {date="Date First" location="Location Second"}

This header has both date and location. The filter should only process the first one it finds (likely date).

1.  First item in ordered list.
2.  Second item in ordered list.

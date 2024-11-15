function Header(el)
    -- Check if the header has attributes
    if el.attributes then
        -- Create a list for Typst raw blocks
        local typst_blocks = {}

        for key, value in pairs(el.attributes) do
            if key == "dates" then
                table.insert(typst_blocks, el)
                table.insert(typst_blocks, pandoc.RawBlock("typst", string.format([=[
#box()[
  #place(
    right,
    dy: -2.5em,
    dx: full-width,
  )[
    #text(fill: primary-color)[#fa-calendar()]
    #emph()[%s]
  ]
]
#h(-0.25em)
]=], value)))
                return typst_blocks
            elseif key == "location" then
                table.insert(typst_blocks, el)
                table.insert(typst_blocks, pandoc.RawBlock("typst", string.format([=[
#box()[
  #place(
    right,
    dy: -2.5em,
    dx: full-width,
  )[
    #text(fill: primary-color)[#fa-location-dot()]
    #emph()[%s]
  ]
]
#h(-0.25em)
]=], value)))
                return typst_blocks
            elseif key == "photo" then
                table.insert(typst_blocks, el)
                table.insert(typst_blocks, pandoc.RawBlock("typst", string.format([=[
#box()[
  #place(
    right,
    dy: -2.5em,
    dx: full-width,
  )[
    #box(
      clip: true,
      stroke: 1.5pt + primary-color,
      radius: (
        bottom-left: 0pt,
        bottom-right: 1000pt,
        top-left: 1000pt,
        top-right: 0pt,
      ),
    )[
      #image(
        "%s",
        width: 120pt,
      )
    ]
  ]
]
#h(-0.25em)
]=], value)))
                return typst_blocks
            end
        end
    end

    if el.classes:includes("hidden") then
        local typst_blocks = {}
        table.insert(typst_blocks, pandoc.RawBlock("typst", "#hidden-heading()["))
        table.insert(typst_blocks, el)
        table.insert(typst_blocks, pandoc.RawBlock("typst", "]"))
        return typst_blocks
    end
    -- If no attributes or no matching key, return the header unchanged
    return el
end

function OrderedList(el)
  local typst_blocks = {}
  table.insert(typst_blocks, pandoc.RawBlock("typst", "#block(width: full-width)["))
  table.insert(typst_blocks, el)
  table.insert(typst_blocks, pandoc.RawBlock("typst", "]"))
  return typst_blocks
end

function Header(el)
    -- Check if the header has attributes
    if el.attributes then
        -- Create a list for Typst raw blocks
        local typst_blocks = {}

        for key, value in pairs(el.attributes) do
            if key == "date" then
                table.insert(typst_blocks, pandoc.RawBlock("typst", "#body-side(["))
                table.insert(typst_blocks, el)
                table.insert(typst_blocks,
                    pandoc.RawBlock("typst", string.format("], side: company-location()[%s])", value)))
                return typst_blocks
            elseif key == "location" then
                table.insert(typst_blocks, pandoc.RawBlock("typst", "#body-side(["))
                table.insert(typst_blocks, el)
                table.insert(typst_blocks, pandoc.RawBlock("typst", string.format("], side: event-date()[%s])", value)))
                return typst_blocks
            elseif key == "photo" then
                table.insert(typst_blocks, pandoc.RawBlock("typst", "#body-side(["))
                table.insert(typst_blocks, el)
                table.insert(typst_blocks,
                    pandoc.RawBlock("typst", string.format("], side: profile-photo(\"%s\"))", value)))
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

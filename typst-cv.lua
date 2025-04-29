local pandoc = require 'pandoc'

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
            -- New logic: Check for 'photo' attribute first
            elseif key == "photo" then
                local photo_path = value
                local photo_width = el.attributes.photowidth or "120pt" -- Get width or use default

                -- No need to calculate absolute path here.
                -- Typst's --root argument (set in build.sh) handles resolving relative paths.

                -- Create the image object string using the path from the attribute and the width
                local image_arg = string.format('image("%s", width: %s)', photo_path, photo_width)

                -- Insert the Typst blocks
                table.insert(typst_blocks, pandoc.RawBlock("typst", "#body-side(["))
                table.insert(typst_blocks, el)
                table.insert(typst_blocks,
                    pandoc.RawBlock("typst", string.format("], side: profile-photo(%s))", image_arg)))
                return typst_blocks
            -- Ignore 'photowidth' key here as it's handled when 'photo' is found
            elseif key == "photowidth" then
                -- Do nothing, processed with 'photo'
            end
            -- Keep handling other keys if necessary (add more elseifs here)

        end -- End of attribute loop
    end -- End of if el.attributes

    -- Handle hidden class separately, after attribute processing
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

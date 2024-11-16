-- Add links to keywords
-- Link URLs are stored in the metadata as a `links` dictionary
local pandoc = require 'pandoc'

function Pandoc(doc)
    local links = doc.meta.links
    if type(links) == "table" then
        local add_links = {
            traverse = 'topdown',
            Link = function(el)
                return el, false -- skip processing already existing lnks
            end,
            Str = function(el)
                for key, url in pairs(links) do
                    if el.text:match(key) then
                        return pandoc.Link(el, url[1].text), false -- don't process inserted Links
                    end
                end
                return el
            end
        }

        doc.blocks = doc.blocks:walk(add_links)
    end
    return doc
end

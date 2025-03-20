GS13.Dreams.CurrentDream = {}
GS13.Dreams.CurrentDreamPointer = 0

local dream_strings = include("gs13/sh_dream_strings.lua"):Split("\n")

function GS13.Dreams.IsDreaming()
    return LocalPlayer():GetNW2Bool("GS13_DREAMER_Dreaming")
end

-- TODO: make this function less hellish
function GS13.Dreams.StartDream()
    local current_dream = {}
    GS13.Dreams.CurrentDream = current_dream
    GS13.Dreams.CurrentDreamPointer = 0
    local dream_type = math.random(1, 1)
    if dream_type == 1 then -- seeing dream
        current_dream[#current_dream+1] = "you see..."

        current_dream[#current_dream+1] = dream_strings[math.random(1, #dream_strings)]
        if math.random(1, 2) == 1 then
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%ADJECTIVE%", GS13.Strings.Adjectives[math.random(1, #GS13.Strings.Adjectives)])
        else
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%ADJECTIVE% ", "")
        end
        if current_dream[#current_dream]:StartsWith("%A% ") then
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%A% ", "a ")
        end
        current_dream[#current_dream] = "... "..current_dream[#current_dream].." ..."

        if math.random(1, 2) == 1 then
            current_dream[#current_dream+1] = ""
            if math.random(1, 20) <= 7 then
                current_dream[#current_dream] = GS13.Strings.Adverbs[math.random(1, #GS13.Strings.Adverbs)].." "
            end
            current_dream[#current_dream] = current_dream[#current_dream]..GS13.Strings.Ingverbs[math.random(1, #GS13.Strings.Ingverbs)]
        else
            current_dream[#current_dream+1] = "will "..GS13.Strings.Verbs[math.random(1, #GS13.Strings.Verbs)]
        end
        current_dream[#current_dream] = "... "..current_dream[#current_dream].." ..."

        if math.random(1, 4) == 1 then return end

        current_dream[#current_dream+1] = dream_strings[math.random(1, #dream_strings)]
        if math.random(1, 2) == 1 then
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%ADJECTIVE%", GS13.Strings.Adjectives[math.random(1, #GS13.Strings.Adjectives)])
        else
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%ADJECTIVE% ", "")
        end
        if current_dream[#current_dream]:StartsWith("%A% ") then
            current_dream[#current_dream] = current_dream[#current_dream]:Replace("%A% ", "a ")
        end
        current_dream[#current_dream] = "... "..current_dream[#current_dream].." ..."
    end
end

timer.Create("GS13_DREAMER_Dreaming", 5, 0, function()
    if not GS13.Dreams.IsDreaming() then GS13.Dreams.CurrentDreamPointer = 0 return end
    if GS13.Dreams.CurrentDreamPointer + 1 > #GS13.Dreams.CurrentDream then
        GS13.Dreams.StartDream()
    end
    GS13.Dreams.CurrentDreamPointer = GS13.Dreams.CurrentDreamPointer + 1
    chat.AddText(Color(200, 200, 200), GS13.Dreams.CurrentDream[GS13.Dreams.CurrentDreamPointer])
end)
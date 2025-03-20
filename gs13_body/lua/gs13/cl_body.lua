local blind_last, blind_last_change = false, -math.huge
function GS13.Body.LastBlindChange()
    return blind_last_change
end
function GS13.Body.IsBlind()
    local blind = LocalPlayer():GetNW2Bool("GS13_BODY_IsBlind", false)
    if blind ~= blind_last then
        blind_last = blind
        blind_last_change = CurTime()
    end
    return blind
end

local deaf_last, deaf_last_change = false, -math.huge
function GS13.Body.LastDeafChange()
    return deaf_last_change
end
function GS13.Body.IsDeaf()
    local deaf = LocalPlayer():GetNW2Bool("GS13_BODY_IsDeaf", false)
    if blind ~= deaf_last then
        deaf_last = deaf
        deaf_last_change = CurTime()
    end
    return deaf
end

include("gs13/body/cl_eyes.lua")
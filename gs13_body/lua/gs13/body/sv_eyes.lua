function GS13.Body.IsBlind(ply)
    if not ply.GS13_Organs then return false end
    return not ply.GS13_Organs.eyes or
           not ply.GS13_Organs.eyes:IsUsable() or
               ply.GS13_Stats.blind or
               ply.GS13_Stats.eyes_covered or
               ply.GS13_Stats.eyes_closed
end

function GS13.Body.CloseEyes(ply)
    if not ply.GS13_Stats then return end
    ply.GS13_Stats.eyes_closed = true
end
function GS13.Body.OpenEyes(ply)
    if not ply.GS13_Stats then return end
    ply.GS13_Stats.eyes_closed = false
end

hook.Add("EntityEmitSound", "GS13_BODY_Echolocation", function(data)
    local handle = thorium.gnet.Start("GS13_BODY_Echolocation")
    handle:WriteTable(data)
    thorium.gnet.Send(handle, "BROADCAST", true, false)
end)
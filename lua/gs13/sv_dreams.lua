function GS13.Dreams.StartDreaming(ply)
    ply.GS13_Stats.dreaming = true
    GS13.Body.CloseEyes(ply)
    ply:SetNW2Bool("GS13_DREAMER_Dreaming", true)
end
function GS13.Dreams.EndDreaming(ply)
    ply.GS13_Stats.dreaming = false
    GS13.Body.OpenEyes(ply)
    ply:SetNW2Bool("GS13_DREAMER_Dreaming", false)
end
function GS13.Dreams.IsDreaming(ply)
    return ply.GS13_Stats.dreaming or false
end
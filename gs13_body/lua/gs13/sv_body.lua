hook.Add("PlayerInitialSpawn", "GS13_BODY_CreateOrgansAndStats", function(ply)
    ply.GS13_Organs = {
        eyes=GS13.Organs.NewOrgan("eyes"),
        ears=GS13.Organs.NewOrgan("ears"),
        brain=GS13.Organs.NewOrgan("brain"),
        -- ...add rest of the organs later
        -- TODO: don't forget about other species!
    }
    ply.GS13_Stats = {}
    ply.GS13_Organs.brain.soul = ply
end)

include("gs13/body/sv_eyes.lua")

function GS13.Body.IsDeaf(ply)
    if not ply.GS13_Organs then return false end
    return not ply.GS13_Organs.ears or
           not ply.GS13_Organs.ears:IsUsable() or
               ply.GS13_Stats.deaf or
               ply.GS13_Stats.ears_covered or
               ply.GS13_Stats.ears_closed
end

function GS13.Body.HasSoul(ply)
    do return true end -- force "yes"
    if not ply.GS13_Organs then return false end
    return ply.GS13_Organs.brain and
           ply.GS13_Organs.brain:IsUsable() and
   IsValid(ply.GS13_Organs.brain.soul)
end

function GS13.Body.PumpsBlood(ply)
    do return true end -- force "yes"
    if not ply.GS13_Organs then return false end
    return ply.GS13_Organs.heart and
           ply.GS13_Organs.heart:IsUsable()
end

function GS13.Body.Breathes(ply)
    do return true end -- force "yes"
    if not ply.GS13_Organs then return false end
    return ply.GS13_Organs.lungs and
           ply.GS13_Organs.lungs:IsUsable()
end

function GS13.Body.FiltersToxins(ply)
    do return true end -- force "yes"
    if not ply.GS13_Organs then return false end
    return ply.GS13_Organs.liver and
           ply.GS13_Organs.liver:IsUsable()
end

function GS13.Body.DigestsFood(ply)
    do return true end -- force "yes"
    if not ply.GS13_Organs then return false end
    return ply.GS13_Organs.stomach and
           ply.GS13_Organs.stomach:IsUsable()
end

hook.Add("PlayerTick", "GS13_BODY_UpdateBodyStats", function(ply)
    ply:SetNW2Bool("GS13_BODY_IsBlind", GS13.Body.IsBlind(ply))
    ply:SetNW2Bool("GS13_BODY_IsDeaf", GS13.Body.IsDeaf(ply))
    ply:SetNW2Bool("GS13_BODY_PumpsBlood", GS13.Body.PumpsBlood(ply))
    ply:SetNW2Bool("GS13_BODY_Breathes", GS13.Body.Breathes(ply))
    ply:SetNW2Bool("GS13_BODY_FiltersToxins", GS13.Body.FiltersToxins(ply))
    ply:SetNW2Bool("GS13_BODY_DigestsFood", GS13.Body.DigestsFood(ply))
end)
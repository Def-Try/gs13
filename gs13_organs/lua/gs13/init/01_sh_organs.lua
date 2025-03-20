return {
    id = "organs",
    version = "1.0.0",
    depends = {
        "base:1.0.0",
        "items:1.0.0"
    },
    priority = GS13_LDP_INIT,
    initialize = function()
        GS13.Organs = {}
        if SERVER then
            include("gs13/sv_organ.lua")
            include("gs13/sv_organs.lua")
        end
        GS13.Log("Organs", "Organ system initialised!")
    end
}
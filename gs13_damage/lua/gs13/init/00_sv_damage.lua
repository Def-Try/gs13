return {
    id = "damage",
    version = "1.0.0",
    depends = {
        "base:1.0.0",
        "organs:1.0.0"
    },
    priority = GS13_LDP_INIT,
    initialize = function()
        GS13.Damage = {}
        include("gs13/sv_damage.lua")
        GS13.Log("Damage", "damage system initialised!")
    end
}
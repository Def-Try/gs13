return {
    id = "body",
    version = "1.0.0",
    depends = {
        "base:1.0.0",
        "organs:1.0.0"
    },
    priority = GS13_LDP_INIT,
    initialize = function()
        GS13.Body = {}
        if CLIENT then
            include("gs13/cl_body.lua")
        end
        if SERVER then
            AddCSLuaFile("gs13/cl_body.lua")
            AddCSLuaFile("gs13/body/cl_eyes.lua")
            include("gs13/sv_body.lua")
        end
        GS13.Log("Body", "Body system initialised!")
    end
}
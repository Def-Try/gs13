return {
    id = "dreams",
    version = "1.0.0",
    depends = {
        "base:1.0.0",
        "config:1.0.0",
        "body:1.0.0"
    },
    config = {
        ["system.dreams.enabled"] = {
            desc="Whether dream system is enabled or not",

            realm="Server",
            default=true,

            is_client_readable=true,
            is_server_readable=true,
            is_client_managable=true,
            is_server_managable=true
        }
    },
    priority = GS13_LDP_POSTINIT,
    initialize = function()
        if not GS13.Config.GetValueServer("system.dreams.enabled") then
            return GS13.Log("Dreams", "Dream system disabled by config")
        end
        GS13.Dreams = {}
        if CLIENT then
            include("gs13/cl_dreams.lua")
        end
        if SERVER then
            AddCSLuaFile("gs13/sh_dream_strings.lua")
            AddCSLuaFile("gs13/cl_dreams.lua")
            include("gs13/sv_dreams.lua")
        end
        GS13.Log("Dreams", "Dream system initialised!")
    end
}
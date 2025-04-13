return {
    id = "items",
    version = "1.0.0",
    depends = {
        "base:1.0.0",
        SERVER and "damage:1.0.0" or nil
    },
    priority = GS13_LDP_INIT,
    initialize = function()
        GS13.Items = {}
        if CLIENT then 
            include("gs13/sh_item.lua")
            include("gs13/sh_items.lua")
        end
        if SERVER then
            AddCSLuaFile("gs13/sh_item.lua")
            AddCSLuaFile("gs13/sh_items.lua")
            include("gs13/sh_item.lua")
            include("gs13/sh_items.lua")
        end
        GS13.Log("Items", "Item system initialised!")
    end
}
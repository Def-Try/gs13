return {
    id = "chat",
    version = "1.0.0",
    depends = {
        "base:1.0.0"
    },
    priority = GS13_LDP_INIT,
    initialize = function()
        GS13.Chat = {}
        if CLIENT then 
            include("gs13/cl_chat.lua")
            include("gs13/cl_chat_ui.lua")
        end
        if SERVER then
            AddCSLuaFile("gs13/cl_chat.lua")
            AddCSLuaFile("gs13/cl_chat_ui.lua")
            include("gs13/sv_chat.lua")
        end
        GS13.Log("Chat", "Chat system initialised!")
    end
}
return {
    id = "strings",
    version = "1.0.0",
    depends = {
        "base:1.0.0"
    },
    priority = GS13_LDP_PRELOAD,
    initialize = function()
        AddCSLuaFile("gs13/strings/adjectives.lua")
        AddCSLuaFile("gs13/strings/adverbs.lua")
        AddCSLuaFile("gs13/strings/ingverbs.lua")
        AddCSLuaFile("gs13/strings/verbs.lua")
        GS13.Strings = {
            Adjectives = include("gs13/strings/adjectives.lua"):Split("\n"),
            Adverbs = include("gs13/strings/adverbs.lua"):Split("\n"),
            Ingverbs = include("gs13/strings/ingverbs.lua"):Split("\n"),
            Verbs = include("gs13/strings/verbs.lua"):Split("\n"),
        }
        GS13.Log("Strings", "Strings loaded")
    end
}
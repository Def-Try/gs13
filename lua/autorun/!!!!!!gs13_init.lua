require("thorium")
if not thorium then
    MsgC(Color(255, 0, 0), "[GS13] [Base] Thorium not installed! GS13 unable to load.\n")
    error("Thorium not installed! GS13 unable to load.")
end

local system_inits = file.Find("gs13/init/*.lua", "LUA")

print("[GS13] [Base] Preinitialising...")

GS13 = GS13 or {}

---Runtime state ""flag"" \
---Shared for both GS13: Gamemode and all other Garry's Mod gamemodes. \
---For checking if we're in GS13 gamemode derivative, see GS13.IsActive.
---```
---"P" = "Preload" -- before the game even finished loading
---"I" = "Init"    -- game finished loading, but GS13 didn't finish loading all systems yet
---"S" = "Start"   -- GS13: GM only. Before round start
---"R" = "Running" -- game finished loading, all systems finished initialising
---```
GS13.RUNTIME = "P"

---Logger function. \
---Logs formatted text to console and files
---@param sys string Nice system name for deciding where to write the log string
---@param msg string Message string, supports string.format formatting.
---@param ... any? Arguments to format with
function GS13.Log(sys, msg, ...)
    print(string.format("[GS13] [%s] "..msg, sys, ...))
end

---Error logger function. \
---Basically the same as GS13.Log, but prints in red color.
---@param sys string Nice system name for deciding where to write the log string
---@param msg string Message string, supports string.format formatting.
---@param ... any? Arguments to format with
function GS13.Error(sys, msg, ...)
    MsgC(Color(255, 0, 0), string.format("[GS13] [%s] "..msg, sys, ...), '\n')
end

---Table of all system tables \
---Each entry is a table returned by corresponding gs13/init files. \
---See gs13/init/sh_base.lua for more info.
GS13.SYSTEMS = {}

---GS13 system loading priorities

GS13_LDP_PRELOAD = 0
GS13_LDP_PREINIT = 1
GS13_LDP_INIT = 2
GS13_LDP_POSTINIT = 3

-- stage 1: discover all possible loadable systems for current realm

local installed_systems = {}

GS13.Log("Base", "Discovering systems")
local client_systems, server_systems = 0, 0
for _, sysfile in ipairs(system_inits) do
    local fsysname = sysfile:sub(7, -5)
    local realm = sysfile:sub(4, 5)
    local should_load =            realm == "sh" or
                        CLIENT and realm == "cl" or
                        SERVER and realm == "sv"
    if (realm == "sh" or realm == "cl") and SERVER then
        AddCSLuaFile("gs13/init/"..sysfile)
        GS13.Log("Base", "  Discovered client system: %s", fsysname)
        client_systems = client_systems + 1
    end
    if should_load then
        local system = include("gs13/init/"..sysfile)
        system.realm = realm
        local sysid = system.id or fsysname
        local version = system.version or "99.99.99"
        local version_split = version:Split(".")
        system.version = {major=tonumber(version_split[1]),
                          minor=tonumber(version_split[2]) or 99,
                          patch=tonumber(version_split[3]) or 99}
        system.vertext = version
        system.priority = system.priority or GS13_LDP_INIT
        GS13.SYSTEMS[sysid] = system
        installed_systems[sysid] = system.version
        GS13.Log("Base", "  Included system: %s", fsysname)
        if SERVER then
            server_systems = server_systems + 1
        else
            client_systems = client_systems + 1
        end
    end
end
if SERVER then
    GS13.Log("Base",
             "Discovered %d client and %d server systems",
             client_systems, server_systems)
else
    GS13.Log("Base", "Discovered  %d client systems", client_systems)
end

-- stage 2: validate dependencies

local validation_failed = false

for sysid, sysdata in pairs(GS13.SYSTEMS) do
    if not sysdata.depends or #sysdata.depends == 0 then continue end
    for _, dependency in ipairs(sysdata.depends) do
        local depid, depver = unpack(dependency:Split(":"))
        local version_split = depver:Split(".")
        local depwantver = {major=tonumber(version_split[1]),
                            minor=tonumber(version_split[2]) or -1,
                            patch=tonumber(version_split[3]) or -1}
        if not installed_systems[depid] then
            validation_failed = true
            GS13.Error("Base",
                       "System dependency validation failed: system %s wants %s (%s or higher), found none",
                       sysid, depid, depver)
            continue
        end
        local deprealver = installed_systems[depid]
        local version_valid = deprealver.major >  depwantver.major or
                              deprealver.major == depwantver.major and (
                                deprealver.minor >  depwantver.minor or
                                deprealver.minor == depwantver.minor and (
                                    deprealver.patch >= depwantver.patch
                                )
                              )
        if not version_valid then
            validation_failed = true
            GS13.Error("Base",
                       "System dependency validation failed: system %s wants %s (%s or higher), found %s",
                       sysid, depid, depver, deprealver.major.."."..deprealver.minor.."."..deprealver.patch)
            continue
        end
    end
end

if validation_failed then
    GS13.Error("Base", "Unable to continue further initialisation: systems version validation failed (see above)")
    error("Unable to continue further initialisation: systems version validation failed (see above)")
end

-- stage 3: start initialising

local function initsys(stage, sysid, sysdata)
    GS13.Log("Base", "Initialising %s system %s %s", stage, sysid, sysdata.vertext)
    xpcall(sysdata.initialize, function(e)
        GS13.Error("Base", "Error occured while initialising %s system %s %s. See traceback below.", stage, sysid, sysdata.vertext)
        GS13.Error("Base", debug.traceback(e))
    end)
end

for sysid, sysdata in pairs(GS13.SYSTEMS) do
    if sysdata.priority ~= GS13_LDP_PRELOAD then continue end
    initsys("preload", sysid, sysdata)
end

hook.Add("Think", "GS13_LOAD_WaitForTick", function()
    hook.Remove("Think", "GS13_LOAD_WaitForTick")
    for sysid, sysdata in pairs(GS13.SYSTEMS) do
        if sysdata.priority ~= GS13_LDP_PREINIT then continue end
        initsys("preinit", sysid, sysdata)
    end
    GS13.RUNTIME = "I"
    for sysid, sysdata in pairs(GS13.SYSTEMS) do
        if sysdata.priority ~= GS13_LDP_INIT then continue end
        initsys("init", sysid, sysdata)
    end
    for sysid, sysdata in pairs(GS13.SYSTEMS) do
        if sysdata.priority ~= GS13_LDP_POSTINIT then continue end
        initsys("postinit", sysid, sysdata)
    end
end)


local __config = {}
__config.Storage =    {Server = {}, Client = {}}
__config.Registered = {Server = {}, Client = {}}

function __config.Register(realm, key, data)
    if realm == "Shared" then
        __config.Registered["Server"][key] = data
        realm = "Client"
    end
    __config.Registered[realm][key] = data
end

file.CreateDir("gs13/config")

function __config.ReloadConfig()
    local cfgfile = file.Read("gs13/config/"..(SERVER and "server" or "client")..".cfg")
    if not cfgfile then return end
    cfgfile = cfgfile:Trim()
    local setval = SERVER and __config.SetValueServer or __config.SetValueClient
    
    for _, line in ipairs(cfgfile:Split("\n")) do
        local key = line:Split(" ")[1]
        local value = table.concat(line:Split(" "), " ", 2)
        setval(key, value)
    end
end

--#region client config control

if SERVER then
    function __config.GetValueClient(client, key)
        if not isentity(client) or not client:IsPlayer() then error("bad argument #1: Player expected, got "..type(client)) end
        if not isstring(key) then error("bad argument #2: string expected, got "..type(key)) end
        local regdata = __config.Registered.Client[key]
        if not regdata then error("bad argument #2: config key not registered") end
        if not regdata.is_server_readable then error("bad argument #2: config key is not server readable") end
        local client_config = __config.Storage.Client[client:SteamID64()]
        if not client_config or not client_config[key] then
            return __config.Registered.Client[key].default
        end
        return client_config[key]
    end
    function __config.SetValueClient(client, key, value)
        if not isentity(client) or not client:IsPlayer() then error("bad argument #1: Player expected, got "..type(client)) end
        if not isstring(key) then error("bad argument #2: string expected, got "..type(key)) end
        local regdata = __config.Registered.Client[key]
        if not regdata then error("bad argument #2: config key not registered") end
        if not regdata.is_server_readable then error("bad argument #2: config key is not server readable") end
        if not regdata.is_server_managable then error("bad argument #2: config key is not server managable") end
        
        local client_config = __config.Storage.Client[client:SteamID64()]
        if not client_config then
            client_config = {}
            __config.Storage.Client[client:SteamID64()] = client_config
        end
        client_config[key] = value
        local handle = thorium.gnet.Start("GS13_CONFIG_CLIENT_UPDATE")
            handle:WriteStringNT(key)
            handle:WriteType(value)
        thorium.gnet.Send(handle, client)
    end
    thorium.gnet.Receive("GS13_CONFIG_CLIENT_UPDATE", function(handle, _, ply)
        local key = handle:ReadStringNT()
        local value = handle:ReadType()
        local client_config = __config.Storage.Client[ply:SteamID64()]
        if not client_config then
            client_config = {}
            __config.Storage.Client[ply:SteamID64()] = client_config
        end
        client_config[key] = value
    end)
end

if CLIENT then
    function __config.GetValueClient(key)
        local client_config = __config.Storage.Client
        if not client_config[key] then
            return __config.Registered.Client[key].default
        end
        return client_config[key]
    end
    function __config.SetValueClient(key, value)
        if not isstring(key) then error("bad argument #1: string expected, got "..type(key)) end
        local regdata = __config.Registered.Client[key]
        if not regdata then error("bad argument #1: config key not registered") end

        local client_config = __config.Storage.Client
        client_config[key] = value

        if not regdata.is_server_readable then return end
        local handle = thorium.gnet.Start("GS13_CONFIG_CLIENT_UPDATE")
            handle:WriteStringNT(key)
            handle:WriteType(value)
        thorium.gnet.Send(handle, game.GetWorld())
    end
    thorium.gnet.Receive("GS13_CONFIG_CLIENT_UPDATE", function(handle, _, _)
        local key = handle:ReadStringNT()
        local regdata = __config.Registered.Client[key]
        if not regdata then return end
        if not regdata.is_server_readable then return end
        if not regdata.is_server_managable then return end
        local value = handle:ReadType()
        local client_config = __config.Storage.Client
        client_config[key] = value
    end)
end

--#endregion

--#region server config control
if SERVER then
    function __config.GetValueServer(key)
        local server_config = __config.Storage.Server
        if not server_config[key] then
            return __config.Registered.Server[key].default
        end
        return server_config[key]
    end
    function __config.SetValueServer(key, value)
        if not isstring(key) then error("bad argument #1: string expected, got "..type(key)) end
        local regdata = __config.Registered.Server[key]
        if not regdata then error("bad argument #1: config key not registered") end

        local server_config = __config.Storage.Server
        server_config[key] = value

        if not regdata.is_client_readable then return end
        local handle = thorium.gnet.Start("GS13_CONFIG_SERVER_UPDATE")
            handle:WriteStringNT(key)
            handle:WriteType(value)
        thorium.gnet.Send(handle, "BROADCAST")
    end
    thorium.gnet.Receive("GS13_CONFIG_SERVER_UPDATE", function(handle, _, ply)
        local key = handle:ReadStringNT()
        local regdata = __config.Registered.Server[key]
        if not regdata then return end
        if not regdata.is_client_readable then return end
        if not regdata.is_client_managable then return end
        if not ply:IsAdmin() then return end
        local value = handle:ReadType()
        local server_config = __config.Storage.Server
        server_config[key] = value

        local handle = thorium.gnet.Start("GS13_CONFIG_SERVER_UPDATE")
            handle:WriteStringNT(key)
            handle:WriteType(value)
        thorium.gnet.Send(handle, "BROADCAST")
    end)
end
if CLIENT then
    function __config.GetValueServer(key)
        if not isstring(key) then error("bad argument #1: string expected, got "..type(key)) end
        local regdata = __config.Registered.Server[key]
        if not regdata then error("bad argument #1: config key not registered") end
        if not regdata.is_client_readable then error("bad argument #1: config key is not client readable") end
        local server_config = __config.Storage.Server
        if not server_config[key] then
            return __config.Registered.Server[key].default
        end
        return server_config[key]
    end
    function __config.SetValueServer(key, value)
        if not isstring(key) then error("bad argument #1: string expected, got "..type(key)) end
        local regdata = __config.Registered.Client[key]
        if not regdata then error("bad argument #1: config key not registered") end
        if not LocalPlayer():IsAdmin() then error("client is not an admin") end
        if not regdata.is_client_readable then error("bad argument #1: config key is not client readable") end
        if not regdata.is_client_managable then error("bad argument #1: config key is not client managable") end
        
        local server_config = __config.Storage.Server
        server_config[key] = value

        local handle = thorium.gnet.Start("GS13_CONFIG_SERVER_UPDATE")
            handle:WriteStringNT(key)
            handle:WriteType(value)
        thorium.gnet.Send(handle, "SERVER")
    end
    thorium.gnet.Receive("GS13_CONFIG_SERVER_UPDATE", function(handle, _, _)
        local key = handle:ReadStringNT()
        local value = handle:ReadType()
        local server_config = __config.Storage.Server
        server_config[key] = value
    end)
end
--#endregion

return {
    id = "config",
    version = "1.0.0",
    depends = {
        "base:1.0.0"
    },
    priority = GS13_LDP_PRELOAD,
    initialize = function()
        GS13.Log("Config", "Config system initialising...")
        GS13.Config = __config
        GS13.Log("Config", "  Parsing other systems `.config` tables")
        for sysid, sysdata in pairs(GS13.SYSTEMS) do
            if not sysdata.config then continue end
            for key, data in pairs(sysdata.config) do
                GS13.Config.Register(data.realm, key, data)
            end
        end
        GS13.Log("Config", "Reloading realm config...")
        GS13.Config.ReloadConfig()
        GS13.Log("Config", "Creating hooks...")
        if SERVER then
            gameevent.Listen("OnRequestFullUpdate")
            hook.Add("OnRequestFullUpdate", "GS13_CONFIG_SendServerConfig", function(data)
                ---@class Player
                local ply = Player(data.userid)
                if ply.GS13_CONFIG_SERVER_CONFIG_SENT then return end
                ply.GS13_CONFIG_SERVER_CONFIG_SENT = true
                for key, value in pairs(__config.Storage.Server) do
                    if not __config.Registered.Server[key].is_client_readable then continue end
                    local handle = thorium.gnet.Start("GS13_CONFIG_SERVER_UPDATE")
                        handle:WriteStringNT(key)
                        handle:WriteType(value)
                    thorium.gnet.Send(handle, ply)
                end
            end)
        else
            hook.Add("Think", "GS13_CONFIG_SendClientConfig", function()
                hook.Remove("Think", "GS13_CONFIG_SendClientConfig")
                for key, value in pairs(__config.Storage.Client) do
                    if not __config.Registered.Client[key].is_server_readable then continue end
                    local handle = thorium.gnet.Start("GS13_CONFIG_CLIENT_UPDATE")
                        handle:WriteStringNT(key)
                        handle:WriteType(value)
                    thorium.gnet.Send(handle, game.GetWorld())
                end
            end)
        end
        GS13.Log("Config", "Config system initialised!")
    end
}
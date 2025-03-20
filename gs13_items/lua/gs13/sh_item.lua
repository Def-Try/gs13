---@class GS13_ITEM
local item = {}

GS13.Items.Registered = {}

function GS13.Items.RegisterType(type_id, data)
    GS13.Items.Registered[type_id] = data
end

function item:New(itype)
    local this = table.Copy(itype)
    setmetatable(this, self)
    self.__index = self
    return this
end

function GS13.Items.NewItem(itype)
    if not GS13.Items.Registered[itype] then error("bad argument #1: has to be registered item type") end
    return item:New(GS13.Items.Registered[itype])
end
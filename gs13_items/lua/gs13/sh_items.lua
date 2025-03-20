---@class GS13_OBJECT
local ___IMPLEMENT_ME_IN_TILING_SYSTEM = {}

GS13.Items.RegisterType("runtime", {
    --- properties ---

    -- item description
    desc="Test item. If you see this and you're not a developer, something really bad happened!",

    -- close examine item description
    closedesc="This... Thing... It looks like a white cube. Your head hurts just from looking at it.",
    
    -- item type
    type="handheld",

    -- whether this item consists of other items. not the same as `type="container"`!
    composite=false,

    -- does this item have usage limit (health)?
    has_health=true,
    -- how much health does this item have (each usage subtracts one, for armor damage is calculated differently)
    health=10,
    -- how much damage does this item "consume" when current holder / wearer was damaged, in fractions of damage
    damage_absorption={
        brute=0.1,
        fire=0.4,
        toxin=0,
        suffocation=0
    },
    -- how much damage this item deals when using it to attack something
    damage_deal={
        brute=0,
        fire=10,
        toxin=0,
        suffocation=0
    },

    -- item model, color and material
    model = "models/hunter/blocks/cube025x025x025.mdl",
    material = "vgui/white",
    color = Color(255, 255, 255),

    --- callbacks / events ---

    --- runs when item was created
    ---@param self GS13_ITEM
    on_create=function(self)
    end,

    --- runs when a body uses this item on something
    ---@param self GS13_ITEM
    ---@param body GS13_BODY
    ---@param other_object GS13_OBJECT
    on_use=function(self, body, other_object)
        GS13.Log("Items", "Used dev item. This should never happen in production!")
    end,

    --- runs when body attacks something with this item
    ---@param self GS13_ITEM
    ---@param body GS13_BODY
    ---@param other_object GS13_OBJECT
    ---@param group GS13_HITGROUP
    ---@return GS13_DAMAGEINFO? damage
    on_attack=function(self, body, other_object, group)
    end,
    
    --- runs when current holder / wearer was damaged
    ---@param self GS13_ITEM
    ---@param body GS13_BODY
    ---@param damage_info GS13_DAMAGEINFO
    ---@return GS13_DAMAGEINFO? absorb how much damage to consume. if nil, absorps according to `damage_absorption`
    on_damage=function(self, body, damage_info)
        return GS13.Damage.DamageInfo({brute=-2394750238647580}) -- kill.
    end,

    -- called every tick while being held / weared
    ---@param self GS13_ITEM
    ---@param body GS13_BODY
    ---@param in_hand boolean
    ---@param weared boolean
    on_held=function(self, body, in_hand, weared)

    end
})
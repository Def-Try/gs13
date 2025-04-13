GS13.Organs.Types = {
    brain={
        slot="head",
        desc="The jumble of neurons, containing so called \"soul\" of a person.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
        soul = NULL, -- supposed to be a Player
    },
    ears={
        slot="head",
        desc="These things that you hear with.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
    eyes={
        slot="head",
        desc="I see you!",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
    moth_eyes={
        slot="head",
        desc="Hey, Bug-Eyes.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },

    heart={
        slot="chest",
        desc="Meaty blob of flesh pumping red liquid through body, keeping it alive.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
    lungs={
        slot="chest",
        desc="Breath in... Breath out...",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
    liver={
        slot="chest",
        desc="Your alcohol filtering buddy.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
    stomach={
        slot="chest",
        desc="Processes food and gives you nutrients.",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },

    appendix={
        slot="groin",
        desc="What is this thing again?",
        health=100,
        outside_body_start_damage_time=120, -- 2 minutes before damage starts kicking in
        outside_body_damage = 0.2, -- gives about 10 minutes for organ to live before it dies
    },
}

local organ = {}

function organ:New(otype)
    local this = table.Copy(otype)
    setmetatable(this, self)
    self.__index = self
    return this
end

function organ:IsUsable()
    return self.health > 25
end

function GS13.Organs.NewOrgan(otype)
    if not GS13.Organs.Types[otype] then error("bad argument #1: has to be an organ type") end
    return organ:New(GS13.Organs.Types[otype])
end
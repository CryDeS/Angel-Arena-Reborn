golem_resist_rock = golem_resist_rock or class({})

LinkLuaModifier( "modifier_golem_big_resist_rock", "creeps/abilities/golems/modifiers/modifier_golem_big_resist_rock", LUA_MODIFIER_MOTION_NONE )

function golem_resist_rock:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_golem_big_resist_rock", { duration = self:GetSpecialValueFor("duration") })
end

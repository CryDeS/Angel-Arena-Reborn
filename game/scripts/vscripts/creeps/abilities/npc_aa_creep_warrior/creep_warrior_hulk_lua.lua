creep_warrior_hulk_lua = class({})
LinkLuaModifier("modifier_creep_warrior_hulk_effect_lua", "creeps/abilities/npc_aa_creep_warrior/modifier_creep_warrior_hulk_effect_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function creep_warrior_hulk_lua:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creep_warrior_hulk_effect_lua", { duration = self.duration })
end

--------------------------------------------------------------------------------
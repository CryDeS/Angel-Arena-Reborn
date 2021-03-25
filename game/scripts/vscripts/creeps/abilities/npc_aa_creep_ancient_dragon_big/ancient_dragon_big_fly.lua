ancient_dragon_big_fly = class({})
LinkLuaModifier("modifier_ancient_dragon_big_fly", "creeps/abilities/npc_aa_creep_ancient_dragon_big/modifier_ancient_dragon_big_fly", LUA_MODIFIER_MOTION_NONE)
---------------------------------------------------------------------------
function ancient_dragon_big_fly:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ancient_dragon_big_fly", { duration = self:GetSpecialValueFor("duration") })
end

---------------------------------------------------------------------------
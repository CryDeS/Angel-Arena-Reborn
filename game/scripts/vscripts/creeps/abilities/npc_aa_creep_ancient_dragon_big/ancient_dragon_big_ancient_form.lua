ancient_dragon_big_ancient_form = class({})
LinkLuaModifier("modifier_ancient_dragon_big_ancient_form","creeps/abilities/npc_aa_creep_ancient_dragon_big/modifier_ancient_dragon_big_ancient_form", LUA_MODIFIER_MOTION_NONE)

function ancient_dragon_big_ancient_form:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ancient_dragon_big_ancient_form", { duration = self:GetSpecialValueFor( "duration" ) } )
end
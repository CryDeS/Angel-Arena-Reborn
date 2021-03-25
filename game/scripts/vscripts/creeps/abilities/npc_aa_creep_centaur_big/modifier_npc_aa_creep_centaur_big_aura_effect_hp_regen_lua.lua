modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua = modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua or class({})
local mod = modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua

function mod:IsHidden()
	return true
end

function mod:IsDebuff()
	return false
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.regen_hp = ability:GetSpecialValueFor( "regen_hp" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function mod:GetModifierConstantHealthRegen( params )
	if self:GetCaster() or self:GetCaster():PassivesDisabled() then return 0 end

	return self.regen_hp or 0
end
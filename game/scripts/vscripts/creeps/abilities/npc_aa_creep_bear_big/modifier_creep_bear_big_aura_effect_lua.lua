modifier_creep_bear_big_aura_effect_lua = modifier_creep_bear_big_aura_effect_lua or class({})
local mod = modifier_creep_bear_big_aura_effect_lua

function mod:IsHidden()
	return false
end

function mod:IsDebuff()
	return false
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonus_attack = ability:GetSpecialValueFor( "bonus_attack" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function mod:GetModifierBaseDamageOutgoing_Percentage( params )
	local caster = self:GetCaster()

	if not caster or caster:PassivesDisabled() then
		return 0
	end
	
	return self.bonus_attack
end

modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua = modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua or class({})
local mod = modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua

function mod:IsHidden()
	return true
end

function mod:IsDebuff()
	return false
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonus_dmg = ability:GetSpecialValueFor( "bonus_dmg" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function mod:GetModifierPreAttack_BonusDamage ( params )
	local caster = self:GetCaster()
	
	if caster and not caster:IsNull() and caster:PassivesDisabled() then
		return 0
	end

	return self.bonus_dmg or 0
end

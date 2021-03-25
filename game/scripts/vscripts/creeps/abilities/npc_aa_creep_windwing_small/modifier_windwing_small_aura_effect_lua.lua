modifier_windwing_small_aura_effect_lua = modifier_windwing_small_aura_effect_lua or class({})

local mod = modifier_windwing_small_aura_effect_lua

function mod:IsHidden() return false end

function mod:IsDebuff() return false end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonus_attack_speed = ability:GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_armor 		= ability:GetSpecialValueFor( "bonus_armor" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed or 0 
end

function mod:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor or 0
end
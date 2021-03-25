modifier_megacreep_warrior_aura_effect_lua = modifier_megacreep_warrior_aura_effect_lua or class({})
local mod = modifier_megacreep_warrior_aura_effect_lua

function mod:IsHidden()
	return false
end

function mod:IsDebuff()
	return true
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.disarmor_start    = ability:GetSpecialValueFor( "disarmor_start" )
	self.time_tick_minute  = ability:GetSpecialValueFor( "time_tick_minute" )
	self.disarmor_per_tick = ability:GetSpecialValueFor( "disarmor_per_tick" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function mod:GetModifierPhysicalArmorBonus( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	if not self.disarmor_per_tick then return 0 end
	
	self.extra_disarmor = math.floor(GameRules:GetGameTime() / (60*self.time_tick_minute)) * self.disarmor_per_tick

	return -(self.disarmor_start + self.extra_disarmor)
end

modifier_creep_bear_big_aura_lua = class({})

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:GetModifierAura()
	return "modifier_creep_bear_big_aura_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

-------------------------------------------------------------------------------

function modifier_creep_bear_big_aura_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

-------------------------------------------------------------------------------
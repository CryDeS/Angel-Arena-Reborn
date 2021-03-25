modifier_skelet_2_aura = modifier_skelet_2_aura or class({})

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:GetModifierAura()
	return "modifier_skelet_2_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_skelet_2_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------

function modifier_skelet_2_aura:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------
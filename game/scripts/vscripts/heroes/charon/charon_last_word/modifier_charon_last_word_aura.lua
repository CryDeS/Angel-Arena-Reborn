modifier_charon_last_word_aura = class({})

--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------
function modifier_charon_last_word_aura:IsPurgable()
	return false
end

----------------------------------------------------------------------------------
function modifier_charon_last_word_aura:IsDebuff()
	return false
end

----------------------------------------------------------------------------------

function modifier_charon_last_word_aura:GetModifierAura()
	return "modifier_charon_last_word_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_charon_last_word_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------

function modifier_charon_last_word_aura:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------
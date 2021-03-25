modifier_ogre_big_aura_emitter = class({})
--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:GetModifierAura()
	return "modifier_ogre_big_aura"
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:GetAuraSearchTeam()
	return self.unit_team or 0
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:GetAuraSearchType()
	return self.unit_type or 0
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura_emitter:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if not IsServer() then return end 
	
	self.unit_type = self:GetAbility():GetAbilityTargetType()
	self.unit_team = self:GetAbility():GetAbilityTargetTeam() 
end

--------------------------------------------------------------------------------
modifier_gnoll_small_two_aura_emitter = class({})
--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:GetModifierAura()
	return "modifier_gnoll_small_two_aura"
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura_emitter:OnCreated( kv )
	if self:GetAbility() then 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
	else 
		self.radius = 0
	end
end

--------------------------------------------------------------------------------
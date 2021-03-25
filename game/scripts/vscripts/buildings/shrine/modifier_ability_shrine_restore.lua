modifier_ability_shrine_restore = modifier_ability_shrine_restore or class({})

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:IsInvulnerable()
	return true
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore:IsStunned()
	return true
end

----------------------------------------------------------------------------------

function modifier_ability_shrine_restore:GetModifierAura()
	return "modifier_ability_shrine_restore_effect"
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_ability_shrine_restore:OnCreated( kv )
	local ability = self:GetAbility()
	if not ability then return end
	
	self.aura_radius = ability:GetSpecialValueFor( "aura_radius" )
	local parent = self:GetParent()

	local particle1 = ParticleManager:CreateParticle( "particles/shrine_restore_radiant/shrine_restore_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )

	ParticleManager:SetParticleControlEnt( particle1, 0, parent, PATTACH_POINT_FOLLOW  , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------

function modifier_ability_shrine_restore:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

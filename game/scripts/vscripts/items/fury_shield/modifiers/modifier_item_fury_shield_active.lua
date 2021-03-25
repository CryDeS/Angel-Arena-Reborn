modifier_item_fury_shield_active = class({})

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_forcestaff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:GetTexture()
	return "../items/fury_shield_big"
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:OnCreated( kv )
	self.block = kv.block_damage or 0
	self.aspeed = self:GetAbility():GetSpecialValueFor("active_bonus_aspeed") or 0
	self.particleFuryShield = ParticleManager:CreateParticle("particles/fury_shield/fury_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particleFuryShield, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:GetModifierAttackSpeedBonus_Constant( params )
	return self.aspeed
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:GetModifierPhysical_ConstantBlock( params )
	return self.block
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_active:OnDestroy( params )
	ParticleManager:DestroyParticle(self.particleFuryShield, false)
end

-----------------------------------------------------------------------------

modifier_satan_curse = class({})

function modifier_satan_curse:IsPurgable( ... )
	return false
end

function modifier_satan_curse:IsDebuff( ... )
	return true
end

function modifier_satan_curse:GetEffectName( ... )
	return "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge_debuff.vpcf"
end

function modifier_satan_curse:CheckState( ... )
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_BLIND] = true,
	}
	return states
end

function modifier_satan_curse:OnCreated( ... )
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_satan_curse:DeclareFunctions( ... )
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_satan_curse:GetModifierMoveSpeedBonus_Percentage( ... )
	return self.slow
end
modifier_satan_trade_attack = class({})

function modifier_satan_trade_attack:IsPurgable()
	return 0
end

function modifier_satan_trade_attack:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_ring_b.vpcf"
end

function modifier_satan_trade_attack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_satan_trade_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, -- GetModifierPreAttack_BonusDamage
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, -- GetModifierProcAttack_Feedback
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, -- GetActivityTranslationModifiers
	}
end

function modifier_satan_trade_attack:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_satan_trade_attack:GetModifierProcAttack_Feedback( params )
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
	ParticleManager:SetParticleControl(particle, 0, params.target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_satan_trade_attack:GetActivityTranslationModifiers( params )
	return "infernal_blade"
end
modifier_possessed_fallen_sword_anim = modifier_possessed_fallen_sword_anim or class({})
local mod = modifier_possessed_fallen_sword_anim

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return false end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end

function mod:GetModifierProcAttack_Feedback( params )
	if not params.target then return end
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
	ParticleManager:SetParticleControl(particle, 0, params.target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end

function mod:GetActivityTranslationModifiers( params )
	return "infernal_blade"
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_ring_b.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

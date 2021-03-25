modifier_gun_joe_calibrated_shot_stun = modifier_gun_joe_calibrated_shot_stun or class({})
mod = modifier_gun_joe_calibrated_shot_stun

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return true end
function mod:DestroyOnExpire() 	return true end

function mod:GetTexture()
	return "custom/gun_joe_calibrated_shot"
end

function mod:CheckState() return 
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
}
end

function mod:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function mod:GetOverrideAnimationRate()
	return 0.2
end

function mod:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function mod:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
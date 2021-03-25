modifier_shadowsong_dark_reflection_stun = modifier_shadowsong_dark_reflection_stun or class({})
local mod = modifier_shadowsong_dark_reflection_stun

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:CheckState() return
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end


function mod:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function mod:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
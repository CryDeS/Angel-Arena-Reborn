modifier_possessed_devil_stomp = modifier_possessed_devil_stomp or class({})
local mod = modifier_possessed_devil_stomp

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
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned_orbit.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function mod:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
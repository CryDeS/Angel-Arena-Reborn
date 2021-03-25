modifier_abyss_warrior_charged_attack_stun = modifier_abyss_warrior_charged_attack_stun or class({})
local mod = modifier_abyss_warrior_charged_attack_stun

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
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned_symbol.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function mod:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
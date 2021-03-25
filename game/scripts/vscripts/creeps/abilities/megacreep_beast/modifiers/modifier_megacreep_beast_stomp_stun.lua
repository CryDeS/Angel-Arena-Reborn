modifier_megacreep_beast_stomp_stun = class({}) or modifier_megacreep_beast_stomp_stun

--------------------------------------------------------------------------------

function modifier_megacreep_beast_stomp_stun:IsDebuff() 	return true end
function modifier_megacreep_beast_stomp_stun:IsStunned() 	return true end
function modifier_megacreep_beast_stomp_stun:IsHidden() 	return false end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_stomp_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_megacreep_beast_stomp_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_stomp_stun:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_stomp_stun:CheckState() return 
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_stomp_stun:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------
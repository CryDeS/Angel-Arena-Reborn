modifier_charon_soul_drain = class({})
--------------------------------------------------------------------------------
function modifier_charon_soul_drain:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_charon_soul_drain:IsStunned()
    return true
end

----------------------------------------------------------------------------------
function modifier_charon_soul_drain:IsPurgable()
    return false
end
----------------------------------------------------------------------------------
function modifier_charon_soul_drain:IsPurgeException()
	return true
end
----------------------------------------------------------------------------------
function modifier_charon_soul_drain:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_charon_soul_drain:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------
function modifier_charon_soul_drain:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_charon_soul_drain:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
function modifier_charon_soul_drain:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_charon_soul_drain:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function modifier_charon_soul_drain:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------
function modifier_charon_soul_drain:OnDestroy(params)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	
	caster:InterruptChannel()
end
--------------------------------------------------------------------------------

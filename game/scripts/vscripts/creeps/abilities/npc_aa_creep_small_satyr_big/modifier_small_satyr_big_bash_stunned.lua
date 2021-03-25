modifier_small_satyr_big_bash_stunned = class({})

function modifier_small_satyr_big_bash_stunned:IsDebuff() return true end
function modifier_small_satyr_big_bash_stunned:IsStunned() return true end
function modifier_small_satyr_big_bash_stunned:IsHidden() return false end

--------------------------------------------------------------------------------
function modifier_small_satyr_big_bash_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_small_satyr_big_bash_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

--------------------------------------------------------------------------------

function modifier_small_satyr_big_bash_stunned:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

--------------------------------------------------------------------------------
function modifier_small_satyr_big_bash_stunned:CheckState() return 
{
    [MODIFIER_STATE_STUNNED] = true,
}
end

function modifier_small_satyr_big_bash_stunned:GetOverrideAnimation(params) return ACT_DOTA_DISABLED end
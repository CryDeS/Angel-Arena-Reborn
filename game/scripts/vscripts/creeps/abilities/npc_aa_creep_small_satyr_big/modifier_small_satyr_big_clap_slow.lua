modifier_small_satyr_big_clap_slow = class({})

------------------------------------------------------------------------------

function modifier_small_satyr_big_clap_slow:IsHidden() return false end
function modifier_small_satyr_big_clap_slow:IsDebuff() return true end
function modifier_small_satyr_big_clap_slow:IsPurgable() return true end 
function modifier_small_satyr_big_clap_slow:DestroyOnExpire() return true end 

------------------------------------------------------------------------------
function modifier_small_satyr_big_clap_slow:DeclareFunctions() return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

--------------------------------------------------------------------------------
function modifier_small_satyr_big_clap_slow:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow
end

------------------------------------------------------------------------------
function modifier_small_satyr_big_clap_slow:OnCreated(kv)
    self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
end

------------------------------------------------------------------------------
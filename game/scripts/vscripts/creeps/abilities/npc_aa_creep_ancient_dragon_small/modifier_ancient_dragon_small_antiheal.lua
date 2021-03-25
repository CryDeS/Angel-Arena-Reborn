modifier_ancient_dragon_small_antiheal = class({})
--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:OnCreated(kv)
    self.percent = self:GetAbility():GetSpecialValueFor("percent")
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:OnRefresh(kv)
    self.percent = self:GetAbility():GetSpecialValueFor("percent")
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:GetDisableHealing()
    return true
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:GetEffectName()
    return "particles/items4_fx/spirit_vessel_damage_ring.vpcf"
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_ancient_dragon_small_antiheal:GetDisableHealing(params)
    return self.percent/100
end

--------------------------------------------------------------------------------
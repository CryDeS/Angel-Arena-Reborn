modifier_soul_merchant_passive = class({})
--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:OnCreated(kv)
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_soul_merchant_passive:GetModifierBonusStats_Strength(kv) return self.bonus_str; end
function modifier_soul_merchant_passive:GetModifierBonusStats_Agility(kv) return self.bonus_agi; end
function modifier_soul_merchant_passive:GetModifierBonusStats_Intellect(kv) return self.bonus_int; end
function modifier_soul_merchant_passive:GetModifierPreAttack_BonusDamage(kv) return self.bonus_damage; end
function modifier_soul_merchant_passive:GetModifierHealthBonus(kv) return self.bonus_health; end

--------------------------------------------------------------------------------
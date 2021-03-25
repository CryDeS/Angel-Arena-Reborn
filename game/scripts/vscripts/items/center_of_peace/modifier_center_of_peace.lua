modifier_center_of_peace = class({})
--------------------------------------------------------------------------------
function modifier_center_of_peace:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:OnCreated(kv)
    self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_manaregen = self:GetAbility():GetSpecialValueFor("bonus_manaregen")
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_center_of_peace:GetModifierManaBonus(kv) return self.bonus_mana; end
function modifier_center_of_peace:GetModifierBonusStats_Intellect(kv) return self.bonus_int; end
function modifier_center_of_peace:GetModifierBonusStats_Agility(kv) return self.bonus_agi; end
function modifier_center_of_peace:GetModifierBonusStats_Strength(kv) return self.bonus_str; end
function modifier_center_of_peace:GetModifierConstantManaRegen(kv) return self.bonus_manaregen; end

--------------------------------------------------------------------------------
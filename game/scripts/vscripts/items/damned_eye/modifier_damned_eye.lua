modifier_damned_eye = class({})
--------------------------------------------------------------------------------
function modifier_damned_eye:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_damned_eye:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_damned_eye:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_damned_eye:OnCreated(kv)
    self.armor = self:GetAbility():GetSpecialValueFor("armor")
    self.all_stats = self:GetAbility():GetSpecialValueFor("all_stats")
    self.health = self:GetAbility():GetSpecialValueFor("health")
    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
end

--------------------------------------------------------------------------------
function modifier_damned_eye:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_damned_eye:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_damned_eye:GetModifierPhysicalArmorBonus(kv) return self.armor; end
function modifier_damned_eye:GetModifierBonusStats_Strength(kv) return self.all_stats; end
function modifier_damned_eye:GetModifierBonusStats_Agility(kv) return self.all_stats; end
function modifier_damned_eye:GetModifierBonusStats_Intellect(kv) return self.all_stats; end
function modifier_damned_eye:GetModifierHealthBonus(kv) return self.health; end
function modifier_damned_eye:GetModifierConstantHealthRegen(kv) return self.health_regen; end

--------------------------------------------------------------------------------
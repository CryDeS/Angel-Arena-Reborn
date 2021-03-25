modifier_ability_shrine_restore_effect = class({})

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:OnCreated(kv)
    self.health_regen_const = self:GetAbility():GetSpecialValueFor("health_regen_const")
    self.mana_regen_const = self:GetAbility():GetSpecialValueFor("mana_regen_const")
    self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
    self.mana_regen_pct = self:GetAbility():GetSpecialValueFor("mana_regen_pct")
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:OnRefresh(kv)
    self.health_regen_const = self:GetAbility():GetSpecialValueFor("health_regen_const")
    self.mana_regen_const = self:GetAbility():GetSpecialValueFor("mana_regen_const")
    self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
    self.mana_regen_pct = self:GetAbility():GetSpecialValueFor("mana_regen_pct")
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:GetModifierConstantHealthRegen(params)
    return self.health_regen_const
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:GetModifierConstantManaRegen(params)
    return self.mana_regen_const
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:GetModifierHealthRegenPercentage(params)
    return self.health_regen_pct
end

--------------------------------------------------------------------------------
function modifier_ability_shrine_restore_effect:GetModifierPercentageManaRegen(params)
    return self.mana_regen_pct
end

--------------------------------------------------------------------------------


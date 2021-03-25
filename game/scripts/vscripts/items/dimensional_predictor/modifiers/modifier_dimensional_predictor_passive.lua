modifier_dimensional_predictor_passive = class({})
--------------------------------------------------------------------------------
function modifier_dimensional_predictor_passive:IsHidden() return true; end

function modifier_dimensional_predictor_passive:IsPurgable() return false; end

function modifier_dimensional_predictor_passive:DestroyOnExpire() return false; end

function modifier_dimensional_predictor_passive:RemoveOnDeath() return false; end

function modifier_dimensional_predictor_passive:GetAttributes() return (MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE); end

--------------------------------------------------------------------------------
function modifier_dimensional_predictor_passive:OnCreated(kv)
    local caster = self:GetParent()




    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_magresist = self:GetAbility():GetSpecialValueFor("bonus_magresist")

    if not IsServer() then return end

    if not caster:IsIllusion() then
        caster:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dimensional_predictor_passive_unique", { duration = -1 })
    end
end

function modifier_dimensional_predictor_passive:OnDestroy(kv)
    if not IsServer() then return end
    local caster = self:GetParent()
    if not caster:IsIllusion() then
        self:GetParent():RemoveModifierByName("modifier_dimensional_predictor_passive_unique")
    end
end

--------------------------------------------------------------------------------
function modifier_dimensional_predictor_passive:DeclareFunctions() return {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end

--------------------------------------------------------------------------------
function modifier_dimensional_predictor_passive:GetModifierBonusStats_Strength(params)
    return self.bonus_strength
end

function modifier_dimensional_predictor_passive:GetModifierAttackSpeedBonus_Constant(params)
    return self.attack_speed
end

function modifier_dimensional_predictor_passive:GetModifierPreAttack_BonusDamage(params)
    return self.bonus_damage
end

function modifier_dimensional_predictor_passive:GetModifierMagicalResistanceBonus(params)
    return self.bonus_magresist
end


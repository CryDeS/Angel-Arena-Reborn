modifier_huntress_aim_shot = modifier_huntress_aim_shot or class({})
--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:IsDebuff()
    return false
end

----------------------------------------------------------------------------------
function modifier_huntress_aim_shot:IsPurgable()
    return false
end

----------------------------------------------------------------------------------
function modifier_huntress_aim_shot:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:GetEffectName()
    return "particles/huntress/huntress_aim_shot/huntress_aim_shot.vpcf"
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:GetModifierBaseAttackTimeConstant()
    if self:GetParent():HasModifier("modifier_huntress_hunting_spirit") then
        return
    else
        self.set_bat_value = self:GetAbility():GetSpecialValueFor("set_bat_value")
        self.set_bat_value = self.set_bat_value + self:GetParent():GetTalentSpecialValueFor("huntress_aim_shot_bonus_bat_tallent")
        return self.set_bat_value
    end
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:GetModifierAttackRangeBonus()
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    return self.bonus_attack_range
end

--------------------------------------------------------------------------------
function modifier_huntress_aim_shot:GetModifierPreAttack_CriticalStrike(params)
    if not IsServer() then return end
    self.crit_damage_pct = self:GetAbility():GetSpecialValueFor("crit_damage_pct")
    if params.target ~= nil and params.attacker == self:GetParent() then
        return self.crit_damage_pct + self:GetParent():GetTalentSpecialValueFor("huntress_aim_shot_bonus_crit_tallent")
    end
end

--------------------------------------------------------------------------------
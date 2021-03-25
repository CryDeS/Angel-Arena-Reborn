modifier_troll_warlord_battle_trance_custom = class({})

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:IsPurgable()
    return false
end
--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:OnCreated(kv)
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:OnCreated(kv)
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:GetEffectName(kv)
    return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:OnAttackLanded(params)
    if not IsServer() then return end
        if params.attacker == self:GetParent() then
            local target = params.target
            if target ~= nil then
                local info = {
                    victim = target,
                    attacker = self:GetParent(),
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_PURE,
                }
                ApplyDamage(info)
        end
    end
end
--------------------------------------------------------------------------------
function modifier_troll_warlord_battle_trance_custom:GetModifierAttackSpeedBonus_Constant(params)
    return self.attack_speed
end
--------------------------------------------------------------------------------
modifier_megacreep_warrior_passive_rage_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_passive_rage_effect_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_passive_rage_effect_lua:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_passive_rage_effect_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_passive_rage_effect_lua:OnCreated( kv )
    local ability = self:GetAbility()

    if not ability then return end

    self.bonus_damage_per_stack = ability:GetSpecialValueFor( "bonus_damage_per_stack" )
end

modifier_megacreep_warrior_passive_rage_effect_lua.OnRefresh = modifier_megacreep_warrior_passive_rage_effect_lua.OnCreated

function modifier_megacreep_warrior_passive_rage_effect_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_passive_rage_effect_lua:GetModifierPreAttack_BonusDamage( params )
    return self.bonus_damage_per_stack * self:GetStackCount()
end

--------------------------------------------------------------------------------
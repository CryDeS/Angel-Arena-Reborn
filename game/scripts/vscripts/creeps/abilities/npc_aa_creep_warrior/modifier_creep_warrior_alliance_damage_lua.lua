modifier_creep_warrior_alliance_damage_lua = class({})

-----------------------------------------------------------------------------
function modifier_creep_warrior_alliance_damage_lua:IsHidden()
    return false
end

-----------------------------------------------------------------------------

function modifier_creep_warrior_alliance_damage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------

function modifier_creep_warrior_alliance_damage_lua:GetModifierPreAttack_BonusDamage(params)
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self:GetStackCount() + 0
end

-------------------------------------------------------------------------------
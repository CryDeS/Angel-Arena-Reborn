modifier_ancient_dragon_big_fly = class({})
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:IsHidden()
    return false
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:OnCreated()
    self.add_ms = self:GetAbility():GetSpecialValueFor("add_ms")
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:OnRefresh()
    self.add_ms = self:GetAbility():GetSpecialValueFor("add_ms")
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING] = true,
    }
    return state
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_fly:GetModifierMoveSpeedBonus_Constant()
    return self.add_ms
end

---------------------------------------------------------------------------
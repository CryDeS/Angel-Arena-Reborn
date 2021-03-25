modifier_item_reverse_active = class({})

--------------------------------------------------------------------------------
function modifier_item_reverse_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:GetTexture()
    return "../items/reverse_big"
end

-------------------------------------------------------------------------------
function modifier_item_reverse_active:CheckState(params)
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return state
end

-------------------------------------------------------------------------------
function modifier_item_reverse_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end

-----------------------------------------------------------------------------
function modifier_item_reverse_active:OnCreated(kv)
    self.phase_movement_speed = self:GetAbility():GetSpecialValueFor("phase_movement_speed")
    self.phase_movement_speed_range = self:GetAbility():GetSpecialValueFor("phase_movement_speed_range")
    self.speed_limit_tooltip = self:GetAbility():GetSpecialValueFor("speed_limit_tooltip")
end

--------------------------------------------------------------------------------
function modifier_item_reverse_active:GetModifierMoveSpeedBonus_Percentage(kv)
    if self:GetParent():IsRangedAttacker() then
        return self.phase_movement_speed_range
    else
        return self.phase_movement_speed
    end
end

-----------------------------------------------------------------------------
function modifier_item_reverse_active:GetModifierIgnoreMovespeedLimit(kv)
    return self.speed_limit_tooltip
end
-----------------------------------------------------------------------------
function modifier_item_reverse_active:GetModifierMoveSpeed_Limit(kv)
    return self.speed_limit_tooltip
end
-----------------------------------------------------------------------------



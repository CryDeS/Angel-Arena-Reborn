modifier_item_reverse = class({})
--------------------------------------------------------------------------------
function modifier_item_reverse:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_reverse:IsPurgable()
    return false
end


function modifier_item_reverse:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_item_reverse:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_reverse:OnCreated(kv)
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

--------------------------------------------------------------------------------
function modifier_item_reverse:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_reverse:GetModifierPreAttack_BonusDamage(kv) return self.bonus_damage; end
function modifier_item_reverse:GetModifierPhysicalArmorBonus(kv) return self.bonus_armor; end
function modifier_item_reverse:GetModifierMoveSpeedBonus_Special_Boots(kv) return self.bonus_movement_speed; end

--------------------------------------------------------------------------------
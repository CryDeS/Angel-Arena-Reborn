modifier_item_shard_satan = class({})
--------------------------------------------------------------------------------
function modifier_item_shard_satan:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan:OnCreated(kv)
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.all_stats = self:GetAbility():GetSpecialValueFor("all_stats")
    self.move_speed_bonus = self:GetAbility():GetSpecialValueFor("move_speed_bonus")
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_shard_satan:GetModifierPreAttack_BonusDamage(kv) return self.damage; end
function modifier_item_shard_satan:GetModifierBonusStats_Strength(kv) return self.all_stats; end
function modifier_item_shard_satan:GetModifierBonusStats_Agility(kv) return self.all_stats; end
function modifier_item_shard_satan:GetModifierBonusStats_Intellect(kv) return self.all_stats; end
function modifier_item_shard_satan:GetModifierMoveSpeedBonus_Constant(kv) return self.move_speed_bonus; end
--------------------------------------------------------------------------------
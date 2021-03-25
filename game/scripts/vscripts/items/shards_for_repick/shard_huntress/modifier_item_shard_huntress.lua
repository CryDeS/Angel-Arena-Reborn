modifier_item_shard_huntress = class({})
--------------------------------------------------------------------------------
function modifier_item_shard_huntress:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress:OnCreated(kv)
    self.all_stats = self:GetAbility():GetSpecialValueFor("all_stats")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_shard_huntress:GetModifierBonusStats_Strength(kv) return self.all_stats; end
function modifier_item_shard_huntress:GetModifierBonusStats_Agility(kv) return self.all_stats; end
function modifier_item_shard_huntress:GetModifierBonusStats_Intellect(kv) return self.all_stats; end
function modifier_item_shard_huntress:GetModifierPreAttack_BonusDamage(kv) return self.damage; end

--------------------------------------------------------------------------------

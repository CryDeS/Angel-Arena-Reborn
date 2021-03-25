modifier_item_shard_hola = class({})
--------------------------------------------------------------------------------
function modifier_item_shard_hola:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_hola:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_hola:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_hola:OnCreated(kv)
    self.all_stats = self:GetAbility():GetSpecialValueFor("all_stats")
    self.health = self:GetAbility():GetSpecialValueFor("health")
    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
end

--------------------------------------------------------------------------------
function modifier_item_shard_hola:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_item_shard_hola:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_shard_hola:GetModifierBonusStats_Strength(kv) return self.all_stats; end
function modifier_item_shard_hola:GetModifierBonusStats_Agility(kv) return self.all_stats; end
function modifier_item_shard_hola:GetModifierBonusStats_Intellect(kv) return self.all_stats; end
function modifier_item_shard_hola:GetModifierHealthBonus(kv) return self.health; end
function modifier_item_shard_hola:GetModifierConstantHealthRegen(kv) return self.health_regen; end

--------------------------------------------------------------------------------
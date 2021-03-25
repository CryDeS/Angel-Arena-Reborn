modifier_item_shard_joe_black = class({})
--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:OnCreated(kv)
    self.armor = self:GetAbility():GetSpecialValueFor("armor")
    self.all_stats = self:GetAbility():GetSpecialValueFor("all_stats")
    self.mag_resist_pct = self:GetAbility():GetSpecialValueFor("mag_resist_pct")
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_shard_joe_black:GetModifierPhysicalArmorBonus(kv) return self.armor; end
function modifier_item_shard_joe_black:GetModifierBonusStats_Strength(kv) return self.all_stats; end
function modifier_item_shard_joe_black:GetModifierBonusStats_Agility(kv) return self.all_stats; end
function modifier_item_shard_joe_black:GetModifierBonusStats_Intellect(kv) return self.all_stats; end
function modifier_item_shard_joe_black:GetModifierMagicalResistanceBonus(kv) return self.mag_resist_pct; end
--------------------------------------------------------------------------------
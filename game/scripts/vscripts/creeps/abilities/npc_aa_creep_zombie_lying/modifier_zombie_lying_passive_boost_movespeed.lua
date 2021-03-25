modifier_zombie_lying_passive_boost_movespeed = class({})

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:IsPurgable()
    return false
end

-----------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:OnCreated(kv)
    if not self:GetAbility() then return end
    self.need_hp_pct = self:GetAbility():GetSpecialValueFor("need_hp_pct")
    self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
    self.bonus = 0
end

-------------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_zombie_lying_passive_boost_movespeed:GetModifierMoveSpeedBonus_Percentage(params)
    if self:GetParent():PassivesDisabled() then return 0 end
    local net_table = CustomNetTables:GetTableValue("heroes", "skills_modifiers") or {}
    local unicalUnitString = tostring(self:GetParent():entindex())
    local bonus_speed
    if not IsServer() then
        bonus_speed = net_table[unicalUnitString .. "_bonusspeedzomdie"]
    else
        local parent = self:GetParent()
        local currentHP = parent:GetHealth()
        local maxHP = parent:GetMaxHealth()
        if maxHP / 100 * self.need_hp_pct >= currentHP then
            bonus_speed = self.bonus_movespeed_pct
            self.bonus = bonus_speed
        else
            bonus_speed = 0
        end
        net_table[unicalUnitString .. "_bonusspeedzomdie"] = bonus_speed
        CustomNetTables:SetTableValue("heroes", "skills_modifiers", net_table)
    end
    return bonus_speed or 0
end

----------------------------------------------------------------------------
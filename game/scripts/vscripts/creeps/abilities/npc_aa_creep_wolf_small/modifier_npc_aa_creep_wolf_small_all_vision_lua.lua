modifier_npc_aa_creep_wolf_small_all_vision_lua = class({})

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:OnCreated(kv)
    self.day_vision = self:GetAbility():GetSpecialValueFor("day_vision")
    self.night_vision = self:GetAbility():GetSpecialValueFor("night_vision")
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:OnRefresh(kv)
    self.day_vision = self:GetAbility():GetSpecialValueFor("day_vision")
    self.night_vision = self:GetAbility():GetSpecialValueFor("night_vision")
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:GetFixedDayVision(params)
    if self:GetParent():PassivesDisabled() then return end
    return self.day_vision
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_all_vision_lua:GetFixedNightVision(params) -- НЕ РАБОТАЕТ БЛЯТЬ
    if self:GetParent():PassivesDisabled() then return end
    return self.night_vision
end

-------------------------------------------------------------------------------
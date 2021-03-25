item_center_of_peace = class({})
LinkLuaModifier("modifier_center_of_peace", 'items/center_of_peace/modifier_center_of_peace', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_center_of_peace_active_channel", 'items/center_of_peace/modifier_center_of_peace_active_channel', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_center_of_peace_active_finish", 'items/center_of_peace/modifier_center_of_peace_active_finish', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_center_of_peace:GetIntrinsicModifierName()
    return "modifier_center_of_peace"
end

--------------------------------------------------------------------------------
function item_center_of_peace:OnSpellStart()

    local caster = self:GetCaster()
    local durationChannel = self:GetChannelTime()

    caster:AddNewModifier(caster, self, "modifier_center_of_peace_active_channel", { duration = durationChannel })
end

--------------------------------------------------------------------------------
function item_center_of_peace:OnChannelFinish(bInterrupted) -- сбилось или нет
    local caster = self:GetCaster()
    caster:RemoveModifierByName("modifier_center_of_peace_active_channel")
    if not bInterrupted then
        local durationFinishBuff = self:GetSpecialValueFor("after_cast_bonus_duration")
        caster:AddNewModifier(caster, self, "modifier_center_of_peace_active_finish", { duration = durationFinishBuff })
    end
end

--------------------------------------------------------------------------------






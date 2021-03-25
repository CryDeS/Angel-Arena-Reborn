modifier_megacreep_warrior_passive_rage_lua = modifier_megacreep_warrior_passive_rage_lua or class({})
local mod = modifier_megacreep_warrior_passive_rage_lua

-----------------------------------------------------------------------------
function mod:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function mod:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.duration = ability:GetSpecialValueFor("duration")
end

mod.OnRefresh = mod.OnCreated

-------------------------------------------------------------------------------
function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED,
    }
    return funcs
end

-------------------------------------------------------------------------------
function mod:OnAttacked(params)
    if self:GetParent():PassivesDisabled() then return end
    if not IsServer() then return end

    if params.target == self:GetParent() and (not self:GetParent():IsIllusion()) then
        params.target:AddNewModifier(params.target, self:GetAbility(), "modifier_megacreep_warrior_passive_rage_effect_lua", { duration = self.duration })
        local stack_count = params.target:GetModifierStackCount("modifier_megacreep_warrior_passive_rage_effect_lua", self:GetParent())
        params.target:SetModifierStackCount("modifier_megacreep_warrior_passive_rage_effect_lua", self:GetParent(), stack_count + 1)
    end
end

-------------------------------------------------------------------------------
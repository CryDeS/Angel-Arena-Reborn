modifier_npc_aa_creep_centaur_small_disarmor_lua = class({})

-----------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_disarmor_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_disarmor_lua:OnCreated(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
    self.chance_pct = self:GetAbility():GetSpecialValueFor("chance_pct")
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_disarmor_lua:OnRefresh(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
    self.chance_pct = self:GetAbility():GetSpecialValueFor("chance_pct")
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_disarmor_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_disarmor_lua:OnAttackLanded(params)
    if self:GetParent():PassivesDisabled() then return end
    if not IsServer() then return end
    local target = params.target
    if target:FindModifierByName("npc_aa_creep_centaur_small_disarmor_cooldown_lua") then return end
    local caster = params.attacker

    if caster == self:GetParent() and RollPercentage(self.chance_pct) then
        target:AddNewModifier(caster, self:GetAbility(), "npc_aa_creep_centaur_small_disarmor_cooldown_lua", { duration = self.cooldown })
        target:AddNewModifier(caster, self:GetAbility(), "modifier_npc_aa_creep_centaur_small_disarmor_effect_lua", { duration = self.duration })
        local stack_count = target:GetModifierStackCount("modifier_npc_aa_creep_centaur_small_disarmor_effect_lua", self:GetParent())
        target:SetModifierStackCount("modifier_npc_aa_creep_centaur_small_disarmor_effect_lua", self:GetParent(), stack_count + 1)
    end
end

-------------------------------------------------------------------------------
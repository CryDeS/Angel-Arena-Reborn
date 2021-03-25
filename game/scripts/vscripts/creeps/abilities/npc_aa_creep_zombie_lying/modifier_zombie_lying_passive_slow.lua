modifier_zombie_lying_passive_slow = class({})

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow: IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow:OnCreated(kv)
    if not self:GetAbility() then return end
    self.duration = self:GetAbility():GetSpecialValueFor("duration")

end

--------------------------------------------------------------------------------

function modifier_zombie_lying_passive_slow:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, }
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow:OnAttackLanded(params)
    if not IsServer() then return end
    local caster = self:GetParent()
    if params.attacker ~= caster then return end
    if caster:PassivesDisabled() then
        return 0
    end
    params.target:AddNewModifier(caster, self:GetAbility(), "modifier_zombie_lying_passive_slow_effect", { duration = self.duration })
end

--------------------------------------------------------------------------------
modifier_demon_archer_runaway = modifier_demon_archer_runaway or class({})
local mod = modifier_demon_archer_runaway

function mod:IsHidden()
    return true
end

function mod:IsPurgable()
    return false
end

function mod:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.duration        = ability:GetSpecialValueFor("duration")
    self.cooldown        = ability:GetSpecialValueFor("cooldown")
    self.bonus_movespeed = ability:GetSpecialValueFor("bonus_movespeed")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE, }
end

function mod:OnTakeDamage(params)
    if not IsServer() then return end

    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end
    if params.unit ~= parent then return end

    local ability = self:GetAbility()

    if ability:GetCooldownTimeRemaining() > 0 then return end

    local part = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(part, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

    parent:AddNewModifier(parent, self, "modifier_invisible", { duration = self.duration })
    parent:AddNewModifier(parent, self, "mod_effect", { duration = self.duration, bonus_movespeed = self.bonus_movespeed })
    ability:StartCooldown(self.cooldown)
end
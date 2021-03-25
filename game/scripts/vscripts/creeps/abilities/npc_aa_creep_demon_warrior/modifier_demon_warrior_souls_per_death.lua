modifier_demon_warrior_souls_per_death = modifier_demon_warrior_souls_per_death or class({})
local mod = modifier_demon_warrior_souls_per_death

function mod:IsHidden() return true end

function mod:IsPurgable() return true end

function mod:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.radius          = ability:GetSpecialValueFor("radius")
    self.souls_per_creep = ability:GetSpecialValueFor("souls_per_creep")
    self.souls_per_hero  = ability:GetSpecialValueFor("souls_per_hero")
end

function mod:DeclareFunctions() return
{
    MODIFIER_EVENT_ON_DEATH,
}
end

local unuseMobsName = 
{
    ["npc_dota_unit_undying_zombie"]        = 1,
    ["npc_dota_unit_undying_zombie_torso"]  = 1,
}

local modifierNameEffect = "modifier_demon_warrior_souls_per_death_effect"

function mod:OnDeath(params)
    if not IsServer() then return end

    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end

    if parent:PassivesDisabled() then return end

    local target = params.unit

    if not target or target:IsNull() then return end

    local currentRange = (parent:GetAbsOrigin() - target:GetAbsOrigin()):Length()
    
    if currentRange <= self.radius then
        if parent:GetTeamNumber() == target:GetTeamNumber() then return end
        if unuseMobsName[target:GetUnitName()] then return end

        parent:AddNewModifier(parent, self:GetAbility(), modifierNameEffect, { duration = -1 })

        local stack_count = parent:GetModifierStackCount(modifierNameEffect, parent)
        
        if target:IsRealHero() then
            parent:SetModifierStackCount(modifierNameEffect, parent, stack_count + self.souls_per_hero or 0)
        elseif target:IsCreep() then
            parent:SetModifierStackCount(modifierNameEffect, parent, stack_count + self.souls_per_creep or 0)
        end
    end
end
modifier_ancient_satyr_big_passive = modifier_ancient_satyr_big_passive or class({})

local mod = modifier_ancient_satyr_big_passive

function mod:IsPurgable() return false end
function mod:IsHidden() return true end
function mod:IsDebuff() return false end

function mod:OnCreated( kv )
    local ability = self:GetAbility()

    if not ability then return end

    self.chance = ability:GetSpecialValueFor( "chance" )
    self.duration = ability:GetSpecialValueFor( "duration" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
    MODIFIER_EVENT_ON_ATTACKED,
}
end

function mod:OnAttacked( params )
    if not IsServer() then return end 
    
    if not self or self:IsNull() then return end

    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end

    if parent ~= params.attacker then return end

    local target = params.target

    if not target or target:IsNull() then return end

    if not RollPercentage(self.chance or 0) then return end 

    local ability = self:GetAbility()

    if not ability or ability:IsNull() then return end

    target:AddNewModifier(parent, ability, "modifier_ancient_satyr_big_passiveslow", { duration = self.duration })
end

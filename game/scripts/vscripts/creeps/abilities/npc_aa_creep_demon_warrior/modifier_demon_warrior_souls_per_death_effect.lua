modifier_demon_warrior_souls_per_death_effect = modifier_demon_warrior_souls_per_death_effect or class({})
local mod = modifier_demon_warrior_souls_per_death_effect

function mod:IsHidden() return false end

function mod:DestroyOnExpire() return true end

function mod:IsDebuff() return false end

function mod:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function mod:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end
skelet_2_heal = class({})

--------------------------------------------------------------------------------
function GetMainStatValue(unit)
    if not IsServer() then return end
    if unit:IsHero() then
        local main_stat = unit:GetPrimaryAttribute()
        local stats_massive = {}
        stats_massive[0] = unit:GetStrength()
        stats_massive[1] = unit:GetAgility()
        stats_massive[2] = unit:GetIntellect()
        return stats_massive[main_stat]
    else
        return 0
    end
end

function skelet_2_heal:OnSpellStart()
    local heal_const = self:GetSpecialValueFor("heal_const")
    local heal_per_main_stat_target_coef = self:GetSpecialValueFor("heal_per_main_stat_target_coef")
    local target = self:GetCursorTarget()
    local totalHeal = heal_const + (GetMainStatValue(target) * heal_per_main_stat_target_coef)

    target:Heal(totalHeal, self)
    local particle = ParticleManager:CreateParticle("particles/skelet_2_heal/skelet_2_heal.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target:GetOrigin())
    ParticleManager:SetParticleControl(particle, 2, target:GetOrigin())
end

--------------------------------------------------------------------------------

modifier_ancient_dragon_big_fire_breath = class({})
-------------------------------------------------------------------------------------------------------------
function modifier_ancient_dragon_big_fire_breath:IsPurgable()
    return true
end

-------------------------------------------------------------------------------------------------------------
function modifier_ancient_dragon_big_fire_breath:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------------------------------------
function DamagePerTimerate(caster, parent, dmgToDeal, timerate, Ability)
    if not IsServer() then return end
    Timers:CreateTimer("ancient_dragon_big_fire_breath" .. tostring(parent:entindex()), {
        useGameTime = true,
        endTime = 0,
        callback = function()
            local damage = {
                victim = parent,
                attacker = caster,
                damage = dmgToDeal,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = Ability,
            }
            ApplyDamage(damage)
            local part = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
            ParticleManager:SetParticleControlEnt(part, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
            if not parent:IsAlive() then return nil end
            return timerate
        end
    })
end

-------------------------------------------------------------------------------------------------------------
function modifier_ancient_dragon_big_fire_breath:OnCreated()
    if not IsServer() then return end
    self.ms_reduction = self:GetAbility():GetSpecialValueFor("ms_reduction")
    self.timerate = self:GetAbility():GetSpecialValueFor("timerate")
    self.DmgPerTick = self:GetAbility():GetSpecialValueFor("damage") / (self:GetAbility():GetSpecialValueFor("duration") / self.timerate)
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    DamagePerTimerate(caster, parent, self.DmgPerTick, self.timerate, ability)
end

-------------------------------------------------------------------------------------------------------------
function modifier_ancient_dragon_big_fire_breath:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_reduction
end

-------------------------------------------------------------------------------------------------------------
function modifier_ancient_dragon_big_fire_breath:OnDestroy(params)
    if not IsServer() then return end
    Timers:RemoveTimer("ancient_dragon_big_fire_breath" .. tostring(self:GetParent():entindex()))
end

-------------------------------------------------------------------------------------------------------------
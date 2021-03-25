modifier_demon_warrior_rupture = class({})
--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:OnCreated(kv)
    if IsServer() then
        local damage_per_unit_pct = self:GetAbility():GetSpecialValueFor("damage_per_unit_pct")
        local max_range_damage = self:GetAbility():GetSpecialValueFor("max_range_damage")
        self.target = self:GetAbility():GetCursorTarget()
        local startPose = self.target:GetOrigin()
        local caster = self:GetAbility():GetCaster()

        self.particleRupture = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.particleRupture, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

        DamagePerMoved(self.target, damage_per_unit_pct, startPose, caster, max_range_damage)
    end
end

-------------------------------------------------------------------------------
function DamagePerMoved(unit, damage, startPose, caster, maxRange)
    if not IsServer() then return end
    local newPose = unit:GetOrigin()
    local oldPose = startPose
    Timers:CreateTimer("npc_aa_demon_warrior_rupture" .. tostring(unit:entindex()), {
        useGameTime = true,
        endTime = 0.01,
        callback = function()
            if not unit:IsAlive() then return end
            newPose = unit:GetOrigin()
            local x = (newPose - oldPose):Length()
            if x <= maxRange then
                local damage2 = x / 100 * damage
                if x > 0.0001 then
                    local info = {
                        victim = unit,
                        attacker = caster,
                        damage = damage2,
                        damage_type = DAMAGE_TYPE_PURE,
                    }
                    ApplyDamage(info)
                end
                oldPose = newPose
            end
            return 0.000001
        end
    })
end

-------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:OnRefresh(kv)
    self.bonus_attack_spd = self:GetAbility():GetSpecialValueFor("damage_per_unit_pct")
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_rupture:OnDestroy(params)
    if not IsServer() then return end
    Timers:RemoveTimer("npc_aa_demon_warrior_rupture" .. tostring(self.target:entindex()))
    ParticleManager:DestroyParticle(self.particleRupture, false)
end

-------------------------------------------------------------------------------


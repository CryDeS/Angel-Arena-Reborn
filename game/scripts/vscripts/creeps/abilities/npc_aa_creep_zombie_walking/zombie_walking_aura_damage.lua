zombie_walking_aura_damage = class({})

--------------------------------------------------------------------------------
function damagePerTimeOnRadius(damage, time, caster, radius)
    if not IsServer() then return end
    Timers:CreateTimer("zombie_walking_aura_damage" .. tostring(caster:entindex()), {
        useGameTime = true,
        endTime = 0.1,
        callback = function()
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    if enemy ~= nil and (not enemy:IsMagicImmune()) or (not enemy:IsInvulnerable()) then
                        local info = {
                            victim = enemy,
                            attacker = caster,
                            damage = damage,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                        }
                        ApplyDamage(info)
                    end
                end
            end
            return time
        end
    })
end

--------------------------------------------------------------------------------
function zombie_walking_aura_damage:OnToggle()
    if not IsServer() then return end
    if self:GetToggleState() then
        local damage_per_second = self:GetSpecialValueFor("damage_per_second")
        local radius = self:GetSpecialValueFor("radius")
        local time_rate_sec = self:GetSpecialValueFor("time_rate_sec")
        local caster = self:GetCaster()
        damagePerTimeOnRadius(damage_per_second, time_rate_sec, caster, radius)

    else
        Timers:RemoveTimer("zombie_walking_aura_damage" .. tostring(self:GetCaster():entindex()))
    end
end

--------------------------------------------------------------------------------
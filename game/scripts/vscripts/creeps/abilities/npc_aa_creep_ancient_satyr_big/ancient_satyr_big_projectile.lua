ancient_satyr_big_projectile = ancient_satyr_big_projectile or class({})

function getEnemies(teamnum, pos, radius, target_team, target_flags)
    local enemies = FindUnitsInRadius(  teamnum,
                                        pos, 
                                        nil, 
                                        radius, 
                                        target_team, 
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                        target_flags, 
                                        0, 
                                        false )

    return enemies or {}
end 

function ancient_satyr_big_projectile:OnSpellStart()
    if not IsServer() then return end

    local already_damaged = {}

    local damage        = self:GetSpecialValueFor("damage")
    local radius        = self:GetSpecialValueFor("start_radius")
    local duration      = self:GetSpecialValueFor("duration")
    local speed         = self:GetSpecialValueFor("speed")

    local teamnum       = self:GetCaster():GetTeamNumber() 
    local center        = self:GetCaster():GetAbsOrigin()
    local target_team   = self:GetAbilityTargetTeam() 
    local target_flags  = self:GetAbilityTargetFlags() 
    local damage_type   = self:GetAbilityDamageType() 

    local enemy_radius  = 300 -- TODO: в конфиг 

    local dir           = Vector(math.cos(0), math.sin(0), 0):Normalized()

    local radius_per_sec = 0 

    local time          = GameRules:GetGameTime()
    local total_spended = 0.0

    local angle = 0 
    local angle_per_sec = math.pi

    local particle_idx = ParticleManager:CreateParticle("particles/items3_fx/lotus_orb_shield.vpcf", PATTACH_POINT, self:GetCaster() )
    --local particle_idx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb.vpcf", PATTACH_POINT, self:GetCaster() )
    ParticleManager:SetParticleControl(particle_idx, 0, center + dir * radius) 

    Timers:CreateTimer(0.0, function() 
        local dt = GameRules:GetGameTime() - time 
        time = time + dt 

        if self and self:GetCaster() and not self:GetCaster():IsNull() then
            center = self:GetCaster():GetAbsOrigin()
        end

        radius = radius + radius_per_sec * dt 
        angle = angle + angle_per_sec * dt 

        dir = Vector(math.cos(angle), math.sin(angle), 0):Normalized()

        local pos = center + dir * radius 

        local enemies = getEnemies(teamnum, pos, enemy_radius, target_team, target_flags)

        ParticleManager:SetParticleControl(particle_idx, 0, pos) 

        for _, enemy in pairs(enemies) do
            if not already_damaged[enemy] then 
                ApplyDamage({
                    victim = enemy, 
                    attacker = self:GetCaster(),
                    damage = damage,
                    damage_type = damage_type,
                    damage_flags = target_flags,
                    ability = self, 
                }) 

                already_damaged[enemy] = true 
            end 
        end 

        total_spended = total_spended + dt 

        if total_spended < duration then 
            return 0.00001
        else 
            --TODO Boom particle 
            ParticleManager:DestroyParticle(particle_idx, false)
            already_damaged = nil 
            return nil 
        end 
    end )
end
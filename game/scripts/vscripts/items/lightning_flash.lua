function Blink(keys)
    local caster = keys.caster
    local caster_point = caster:GetAbsOrigin()
    local target_point = keys.target_points[1]
    local difference = target_point - caster_point
    local max_range = keys.BlinkRange
    local radius = keys.Radius
    local damage = keys.Damage / 100

    ProjectileManager:ProjectileDodge(caster)

    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
    caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

    if difference:Length2D() > max_range then
        target_point = caster_point + difference:Normalized() * max_range
    end

	caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(caster, target_point, false)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)

    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

    if not units then return end

    for _, target in pairs(units) do
        local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_explosion_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
        ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, 1000))
        ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
        ApplyDamage({ victim = target, attacker = caster, damage = target:GetHealth() * damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end

    caster:EmitSound("Hero_Leshrac.Lightning_Storm")
end

function OnTakeDamage(keys)
	local caster = keys.caster
    local attacker = keys.attacker
    local ability = keys.ability
    local cooldown = keys.Cooldown
    local damage = keys.Damage or 0
	if caster:GetTeamNumber() == attacker:GetTeamNumber() then return end
    if damage < 10 then return end

    if attacker and attacker:IsHero() then
        ability:StartCooldown(3)
    end
end
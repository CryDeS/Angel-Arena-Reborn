item_soul_collector = item_soul_collector or class({})
local ability = item_soul_collector

LinkLuaModifier("modifier_soul_collector_passive", 'items/soul_collector/modifier_soul_collector_passive', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_collector_active_debuff", 'items/soul_collector/modifier_soul_collector_active_debuff', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
    return "modifier_soul_collector_passive"
end

function ability:CreateWave( caster, range, point )
    local direction = ( point - caster:GetAbsOrigin() )

    local dirLen = direction:Length()

    if direction:Length() == 0 then
        direction = Vector(1, 0, 0)
    else
        direction = direction / dirLen
    end

    local info =
    {
        Ability          = self,
        EffectName       = "particles/soul_collector/soul_collector_wave.vpcf",
        vSpawnOrigin     = caster:GetOrigin(),
        fDistance        = range,
        fStartRadius     = self:GetSpecialValueFor("wave_width_init"),
        fEndRadius       = self:GetSpecialValueFor("wave_width_end"),
        Source           = caster,
        iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        bDeleteOnHit     = false,
        vVelocity        = direction * self:GetSpecialValueFor("wave_speed"),
    }

    ProjectileManager:CreateLinearProjectile(info)
end

function ability:CreateHealProjectile(hSource, hTarget, bDodgeable)
    local info =
    {
        Target              = hTarget,
        Source              = hSource,
        Ability             = self,
        EffectName          = "particles/soul_collector/soul_collector_in_caster.vpcf",
        iMoveSpeed          = self:GetSpecialValueFor("projectile_speed"),
        vSourceLoc          = hSource:GetAbsOrigin(),
        bDrawsOnMinimap     = false,
        bDodgeable          = false,
        bIsAttack           = false,
        bVisibleToEnemies   = true,
        bReplaceExisting    = false,
        bProvidesVision     = false,
    }

    ProjectileManager:CreateTrackingProjectile(info)
end

function ability:OnSpellStart()
    if not IsServer() then return end
    if not self or self:IsNull() then return end

    local caster = self:GetCaster()

    if not caster or caster:IsNull() then return end

    local range = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()
    local point = self:GetCursorPosition()

    self:CreateWave( caster, range, point )
end

function ability:OnProjectileHitEnemy(hTarget, damage)
    if not self or self:IsNull() then return end

    if not hTarget or hTarget:IsNull() then return end

    local caster = self:GetCaster()

    local projectile_speed = self:GetSpecialValueFor("projectile_speed")

    ApplyDamage({
        victim      = hTarget,
        attacker    = caster,
        damage      = damage,
        damage_type = self:GetAbilityDamageType(),
        ability     = self
    })

    local duration = self:GetSpecialValueFor("decrease_heal_duration")
    
    hTarget:AddNewModifier(caster, self, "modifier_soul_collector_active_debuff", { duration = duration })
    
    if hTarget:IsCreep() then return end

    if caster and not caster:IsNull() then
        self:CreateHealProjectile( hTarget, caster )
    end
end

function ability:OnProjectileHitFriend(hTarget, value)
    hTarget:Heal(value, self)
end

function ability:OnProjectileHit(hTarget, vLocation)
    if not self or self:IsNull() or not hTarget or hTarget:IsNull() then return end

    local caster        = self:GetCaster()
    local att_damage    = caster:GetPrimaryStatValue() * (self:GetSpecialValueFor("mainstat_to_dmg_pct") / 100)
    local damage_const  = self:GetSpecialValueFor("damage")

    if hTarget == caster then
        self:OnProjectileHitFriend(hTarget, (att_damage + damage_const)*self:GetSpecialValueFor("heal_pct"))
    else
        self:OnProjectileHitEnemy(hTarget, att_damage + damage_const)
    end
end
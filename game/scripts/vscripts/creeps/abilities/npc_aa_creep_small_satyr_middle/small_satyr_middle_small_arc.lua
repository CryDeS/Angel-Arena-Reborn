small_satyr_middle_small_arc = class({})

------------------------------------------------------------------------------
function small_satyr_middle_small_arc:OnSpellStart()
    self.nextEnemy = self:GetCursorTarget()
    self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
    self.bounces = self:GetSpecialValueFor("bounces")
    if self.nextEnemy:TriggerSpellAbsorb(self) then
        return
    end
    self.bounces = 0
    self:ShotArcTarget(self:GetCaster(), self.nextEnemy)
end

------------------------------------------------------------------------------
function small_satyr_middle_small_arc:ShotArcTarget(firstTarget, secondTarget)
    local info =
    {
        Target = secondTarget,
        Source = firstTarget,
        Ability = self,
        EffectName = "particles/small_satyr_middle_small_arc/small_satyr_middle_small_arc.vpcf",
        iMoveSpeed = self.projectile_speed,
        vSourceLoc = firstTarget:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
    }
    ProjectileManager:CreateTrackingProjectile(info)
end


------------------------------------------------------------------------------
function small_satyr_middle_small_arc:OnProjectileHit(hTarget, vLocation)
    if self.bounces > self.bounces-1 then return end
    local info = {
        victim = hTarget,
        attacker = self:GetCaster(),
        damage = self:GetSpecialValueFor("damage"),
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage( info )
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    if #enemies == 1 then return end
    while self.nextEnemy == hTarget do
        self.nextEnemy = enemies[RandomInt(1, #enemies)]
    end
    self.bounces = self.bounces + 1
    self:ShotArcTarget(hTarget, self.nextEnemy)
end

------------------------------------------------------------------------------
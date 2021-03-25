item_life_catcher = item_life_catcher or class({})

LinkLuaModifier("modifier_life_catcher_passive", 'items/life_catcher/modifiers/modifier_life_catcher_passive', LUA_MODIFIER_MOTION_NONE)

function item_life_catcher:GetIntrinsicModifierName() return "modifier_life_catcher_passive"; end

function item_life_catcher:CreateParticle(sParticleName, hSource, hTarget, bDodgeable)
    if not hSource or hSource:IsNull() then return end
    if not hTarget or hTarget:IsNull() then return end
    if not self or self:IsNull() then return end

	local info =
    {
        Target = hTarget,
        Source = hSource,
        Ability = self,
        EffectName = sParticleName,
        iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
        vSourceLoc = hSource:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = bDodgeable,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = false,
    }
    ProjectileManager:CreateTrackingProjectile(info)
end 

function item_life_catcher:OnSpellStart()
    if not IsServer() then return end

    if not self or self:IsNull() then return end

    local target = self:GetCursorTarget()

    if not target or target:IsNull() then return end

    local caster = self:GetCaster()

    if not caster or caster:IsNull() then return end

    if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end

    self:CreateParticle("particles/life_catcher/life_catcher_out.vpcf", caster, target, true)
end

function item_life_catcher:OnProjectileHitEnemy(hTarget, value)
    local caster = self:GetCaster()

    ApplyDamage({
        victim = hTarget,
        attacker = caster,
        damage = value,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    })

    if caster and not caster:IsNull() then
        self:CreateParticle("particles/life_catcher/life_catcher_in.vpcf", hTarget, caster, false)
    end
end 

function item_life_catcher:OnProjectileHitFriend(hTarget, value)
    hTarget:Heal(value, self)  
end

function item_life_catcher:OnProjectileHit(hTarget, vLocation)
    if not self or self:IsNull() then return end
    if not hTarget or hTarget:IsNull() then return end

    local damage = self:GetSpecialValueFor("damage")

    local caster = self:GetCaster()

    if caster and not caster:IsNull() and caster.GetPrimaryStatValue then 
        damage = damage + caster:GetPrimaryStatValue() * (self:GetSpecialValueFor("mainstat_to_dmg") / 100)
    end

    if hTarget == caster then
        self:OnProjectileHitFriend(hTarget, damage)
    else 
        self:OnProjectileHitEnemy(hTarget, damage)
    end
end 

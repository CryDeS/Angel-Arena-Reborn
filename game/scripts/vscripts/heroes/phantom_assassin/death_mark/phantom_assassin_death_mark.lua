phantom_assassin_death_mark = phantom_assassin_death_mark or class({})

LinkLuaModifier("modifier_phantom_assassin_death_mark_debuff", 'heroes/phantom_assassin/death_mark/modifier_phantom_assassin_death_mark_debuff', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_death_mark_bonus_agi", 'heroes/phantom_assassin/death_mark/modifier_phantom_assassin_death_mark_bonus_agi', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function phantom_assassin_death_mark:CreateParticle(sParticleName, hSource, hTarget, bDodgeable)
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

--------------------------------------------------------------------------------
function phantom_assassin_death_mark:OnSpellStart()
    local target = self:GetCursorTarget()

    if not IsServer() then return end

    if target:TriggerSpellAbsorb(self) then return end
    self.duration = self:GetSpecialValueFor("duration")

    self:CreateParticle("particles/units/phantom_assassin/death_mark/phantom_assassin_death_mark.vpcf", self:GetCaster(), target, true)
end

--------------------------------------------------------------------------------
function phantom_assassin_death_mark:OnProjectileHit(hTarget, vLocation)
    local caster = self:GetCaster()

    if hTarget:HasModifier("modifier_phantom_assassin_death_mark_debuff") then
        hTarget:AddNewModifier(caster, self, "modifier_phantom_assassin_death_mark_debuff", { duration = self.duration })
        local currentStack = hTarget:GetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", caster)
        hTarget:SetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", caster, currentStack)
    else
        hTarget:AddNewModifier(caster, self, "modifier_phantom_assassin_death_mark_debuff", { duration = self.duration })
        hTarget:SetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", caster, 1)
    end
end
--------------------------------------------------------------------------------

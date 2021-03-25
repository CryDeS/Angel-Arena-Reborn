ancient_dragon_big_fire_breath = class({})
LinkLuaModifier("modifier_ancient_dragon_big_fire_breath", "creeps/abilities/npc_aa_creep_ancient_dragon_big/modifier_ancient_dragon_big_fire_breath", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------------------------------------------------------------------------
function ancient_dragon_big_fire_breath:OnSpellStart()
    if not IsServer() then return end
    self.breath_speed = self:GetSpecialValueFor("breath_speed")
    self.breath_width_initial = self:GetSpecialValueFor("breath_width_initial")
    self.breath_width_end = self:GetSpecialValueFor("breath_width_end")
    self.breath_distance = self:GetSpecialValueFor("breath_distance")
    local caster = self:GetCaster()
    caster:EmitSound("Hero_Lina.DragonSlave.Cast")

    local vPos
    if self:GetCursorTarget() then
        vPos = self:GetCursorTarget():GetOrigin()
    else
        vPos = self:GetCursorPosition()
    end

    local vDirection = vPos - caster:GetOrigin()
    vDirection = vDirection:Normalized()

    self.breath_speed = self.breath_speed * (self.breath_distance / (self.breath_distance - self.breath_width_initial))

    local breath_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(breath_pfx, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    --    ParticleManager:SetParticleControlEnt( breath_pfx, 1, caster, PATTACH_ABSORIGIN, "attach_hitloc", vDirection*self.breath_speed, true )
    ParticleManager:SetParticleControlEnt(breath_pfx, 3, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", vPos, true)
    ParticleManager:SetParticleControlEnt(breath_pfx, 9, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
--
--
--    --    ParticleManager:SetParticleControl(breath_pfx, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl(breath_pfx, 1, vDirection * self.breath_speed)
--    --    ParticleManager:SetParticleControl(breath_pfx, 3, vPos )
--    --    ParticleManager:SetParticleControl(breath_pfx, 9, caster:GetAbsOrigin() )
--
--

    local x = 1;
    local vec = caster:GetForwardVector()
    ParticleManager:SetParticleControlEnt(breath_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "...", caster:GetAbsOrigin() + vec*5, true)
    Timers:CreateTimer("ancient_dragon_big_fire_breath" .. tostring(caster:entindex()), {
        useGameTime = true,
        endTime = 0,
        callback = function()
            local vSoso = vPos - Vector(0,0,x)
            local vSoso2 = caster:GetAbsOrigin()- Vector(0,0,x)
            print (vSoso)
--            ParticleManager:SetParticleControlEnt(breath_pfx, 0, caster, PATTACH_ABSORIGIN, "attach_hitloc", vSoso2, true)
--            ParticleManager:SetParticleControlEnt(breath_pfx, 3, caster, PATTACH_ABSORIGIN, "attach_hitloc", vSoso, true)
--            ParticleManager:SetParticleControlEnt(breath_pfx, 9, caster, PATTACH_ABSORIGIN, "attach_hitloc", vSoso2, true)

            x = x+1;
            return nil
        end
    })

--
    Timers:CreateTimer(self.breath_distance / self.breath_speed, function()
        Timers:RemoveTimer("ancient_dragon_big_fire_breath" .. tostring(caster:entindex()))
        ParticleManager:DestroyParticle(breath_pfx, false)
        return nil
    end)

    local info = {
--        EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
        Ability = self,
        vSpawnOrigin = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("follow_overhead")),
        fStartRadius = self.breath_width_initial,
        fEndRadius = self.breath_width_end,
        vVelocity = vDirection * self.breath_speed,
        fDistance = self.breath_distance,
        Source = caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    }

    ProjectileManager:CreateLinearProjectile(info)
    caster:EmitSound("Hero_Lina.DragonSlave")
end

-------------------------------------------------------------------------------------------------------------
function ancient_dragon_big_fire_breath:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsMagicImmune()) and (not hTarget:IsInvulnerable()) then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_ancient_dragon_big_fire_breath", { duration = self:GetSpecialValueFor("duration") })
    end
end

-------------------------------------------------------------------------------------------------------------
modifier_harpy_small_dive_active = class({})
--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_harpy_small_dive_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------

function modifier_harpy_small_dive_active:CheckState() return 
{
    [MODIFIER_STATE_STUNNED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_harpy_small_dive_active:OnCreated(kv)
    if not IsServer() then return end 

    self.caster = self:GetParent()
    self.fSpeed = kv.speed
    self.height = kv.height
    self.damage = kv.damage
    self.damage_self = kv.damage_self 
    self.radius = kv.radius
    self.duration = kv.duration
    self.sPoint = self:GetParent():GetAbsOrigin()
    self.nTeam = self:GetParent():GetTeamNumber()
    self.vPoint = self:GetCaster():GetAbsOrigin() + Vector(0, 0, self.height)
    self.step = 1

    local motion = self:ApplyVerticalMotionController()

    if not motion then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:UpdateVerticalMotion(me, dt)
    if not IsServer() then return end 

    if self and self:GetAbility() ~= nil and self:GetParent() ~= nil and self:GetParent():IsAlive() then
        local vParent_point = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsAlive() then
            local dir

            if self.step == -1 then 
                dir = (vParent_point - self.sPoint)
            else
                dir = (self.vPoint - vParent_point)  
            end 
            local length = dir:Length()
            dir = dir:Normalized()

            local newPos

            if length < self.fSpeed * dt then
                if self.step == -1 then
                   self:GetParent():InterruptMotionControllers(true)
                end 
                newPos = vParent_point + self.step * dir * length * dt

                self.step = -1
                self.fSpeed = self.fSpeed * 3
            else 
                newPos = vParent_point + self.step * dir * self.fSpeed * dt
            end

            self:GetParent():SetAbsOrigin( newPos )
        end

    else
        self:GetParent():InterruptMotionControllers(true)
    end
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:OnVerticalMotionInterrupted()
    if not IsServer() then return end 

    self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active:OnDestroy()
    if IsServer() then
        GridNav:DestroyTreesAroundPoint(self.sPoint, 150, true)
        self:GetParent():InterruptMotionControllers(true)
        local enemies = FindUnitsInRadius(self.nTeam, self.sPoint, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

        if enemies and #enemies > 0 then
            for _, enemy in pairs(enemies) do
                if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
                    local info = {
                        victim = enemy,
                        attacker = self:GetParent(),
                        ability = self:GetAbility(),
                        damage = self.damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                    }
                    ApplyDamage(info)
                    enemy:AddNewModifier(self.caster, self, "modifier_harpy_small_dive_active_stun", { duration = self.duration })
                end
            end
        end

        hParticle = ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(hParticle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(hParticle, 2, Vector(189, 183, 107))
        ParticleManager:ReleaseParticleIndex(hParticle)

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetParent(), 
            damage = self.damage_self,
            ability = self:GetAbility(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
        })
    end
end
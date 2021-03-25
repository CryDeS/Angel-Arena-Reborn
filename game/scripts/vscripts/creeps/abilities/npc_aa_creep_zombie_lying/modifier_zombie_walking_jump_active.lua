modifier_zombie_walking_jump_active = class({})
--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

----------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:OnCreated(kv)
    if IsServer() then
        self.fSpeed = kv.speed
        self.target = self:GetAbility():GetCursorTarget()
        self.vPoint = self.target:GetAbsOrigin()
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
        self.particleJump = ParticleManager:CreateParticle("particles/zombie_walking_jump/zombie_walking_jump.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.particleJump, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    end
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if self and self:GetAbility() ~= nil and self:GetParent() ~= nil and self:GetParent():IsAlive() then
            local vParent_point = self:GetParent():GetAbsOrigin()
            if (self.vPoint - vParent_point):Length2D() < 150 then
                self:GetParent():InterruptMotionControllers(true)
            else
                if self:GetParent():IsAlive() then
                    self:GetParent():SetAbsOrigin(vParent_point + ((self.vPoint - vParent_point):Normalized()) * self.fSpeed)
                end
            end

        else
            self:GetParent():InterruptMotionControllers(true)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:OnHorizontalMotionInterrupted()
    ParticleManager:DestroyParticle(self.particleJump, false)
    if IsServer() then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:OnDestroy()
    if IsServer() then
        local vT = self.target:GetAbsOrigin():Length2D()
        local vP = self:GetParent():GetAbsOrigin():Length2D()
        if vP - vT <= 160 then
            local info = {
                victim = self.target,
                attacker = self:GetParent(),
                damage = self.damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage(info)
        end
        self:GetParent():InterruptMotionControllers(true)
    end
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_jump_active:GetOverrideAnimation(params)
    return ACT_DOTA_ATTACK
end

--------------------------------------------------------------------------------
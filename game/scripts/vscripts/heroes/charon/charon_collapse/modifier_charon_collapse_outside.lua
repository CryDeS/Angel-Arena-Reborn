modifier_charon_collapse_outside = modifier_charon_collapse_outside or class({})

local mod = modifier_charon_collapse_outside

--------------------------------------------------------------------------------
function mod:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function mod:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function mod:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function mod:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function mod:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function mod:OnCreated(kv)
    if not IsServer() then return end

    local vals = {}
    for i in kv.point:gmatch("%S+") do
        table.insert(vals, i)
    end

    local point = Vector(tonumber(vals[1]), tonumber(vals[2]), tonumber(vals[3]))
    self.point = point
    self.duration = kv.dur
    self.radius = kv.radius
    self.step = self.radius / self.duration
    self.target = self:GetParent()
    self.dir = (self.target:GetAbsOrigin() - self.point):Normalized()
    local motion = self:ApplyHorizontalMotionController()

    if not motion then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
function mod:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end
    if self and self:GetAbility() and self:GetParent() and self:GetParent():IsAlive() then
        local step = self.dir * (self.step * dt)
        local origin = self:GetParent():GetAbsOrigin()
        local new_pos = origin + step
        self:GetParent():SetAbsOrigin(new_pos)
    else
        if self and self:GetParent() then
            self:GetParent():InterruptMotionControllers(true)
        end
    end
end

--------------------------------------------------------------------------------
function mod:OnHorizontalMotionInterrupted()
    if not IsServer() then return end
    self:Destroy()
end

--------------------------------------------------------------------------------
function mod:OnDestroy()
    if not IsServer() then end
    if not self then return end
    
    local target = self.target

    self.target = nil

    if not target then return end
    if target:IsNull() then return end

    target:InterruptMotionControllers(true)
end
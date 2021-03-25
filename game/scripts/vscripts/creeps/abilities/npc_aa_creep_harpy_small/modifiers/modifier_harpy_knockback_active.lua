modifier_harpy_knockback_active = class({})
--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_harpy_knockback_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------

function modifier_harpy_knockback_active:CheckState() return 
{
    [MODIFIER_STATE_STUNNED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_harpy_knockback_active:OnCreated(kv)
    if not IsServer() then return end 

    self.point = Vector(0,0,0)
    local vals = {}
    
    for i in kv.point:gmatch("%S+") do
       table.insert(vals, i)
    end

    point = Vector(tonumber(vals[1]), tonumber(vals[2]), tonumber(vals[3]))

    self.point      = point 
    self.duration   = kv.dur
    self.radius     = kv.radius
    self.step       = self.radius / self.duration
    self.dir        = ( self:GetParent():GetAbsOrigin() - self.point):Normalized() 

    local motion = self:ApplyHorizontalMotionController()

    if not motion then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end 

    if self and self:GetAbility() ~= nil and self:GetParent() ~= nil and self:GetParent():IsAlive() then
        local step = self.dir * (self.step * dt)
        local origin = self:GetParent():GetAbsOrigin() 
        
        local new_pos = origin + step
        self:GetParent():SetAbsOrigin( new_pos )
    else
        self:GetParent():InterruptMotionControllers(true)
    end
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:OnHorizontalMotionInterrupted()
    if not IsServer() then return end 

    self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_harpy_knockback_active:OnDestroy()
    if IsServer() then
        self:GetParent():InterruptMotionControllers(true)
    end
end
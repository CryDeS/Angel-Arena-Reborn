modifier_small_satyr_big_jump = class({}) or modifier_small_satyr_big_jump

--------------------------------------------------------------------------------

function modifier_small_satyr_big_jump:IsDebuff() 	return false end
function modifier_small_satyr_big_jump:IsStunned() 	return true end
function modifier_small_satyr_big_jump:IsHidden() 	return true end
function modifier_small_satyr_big_jump:IsPurgable() return false end

--------------------------------------------------------------------------------
function modifier_small_satyr_big_jump:CheckState() return 
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_small_satyr_big_jump:OnCreated(kv)
	if not IsServer() then return end 

	self.duration = kv.duration
	self.startPos = Vector(kv.sx, kv.sy, kv.sz)
	self.endPos = Vector(kv.x, kv.y, kv.z)

	self.time = 0 

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end

	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
function modifier_small_satyr_big_jump:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end 

    if not self:GetParent() or not self:GetParent():IsAlive() then 
    	self:GetParent():InterruptMotionControllers(true)
    	return 
    end 
    
    self.time = self.time + dt 

    if self.time > self.duration then
    	self.time = self.duration 
    end 

    local pct = self.time/self.duration

    local dir = (self.endPos - self.startPos)
    local distance = (self.endPos - self.startPos):Length() 

    dir.z = dir.z + 10
    dir = dir:Normalized()

    local pos = self.startPos + dir*distance*pct 

    self:GetParent():SetAbsOrigin(pos)

    if pct > 0.9 then
    	self:GetParent():InterruptMotionControllers(true)
    	self:Destroy() 
    end 
end

function modifier_small_satyr_big_jump:UpdateVerticalMotion(me, dt)
    if not IsServer() then return end 

    if not self:GetParent() or not self:GetParent():IsAlive() then 
    	self:GetParent():InterruptMotionControllers(true)
    	return 
    end 
    
    self.time = self.time + dt 

    if self.time > self.duration then
    	self.time = self.duration 
    end 

    local pct = self.time/self.duration

    local dir = (self.endPos - self.startPos)
    local distance = (self.endPos - self.startPos):Length() 

    dir.z = dir.z + 10
    dir = dir:Normalized()

    local pos = self.startPos + dir*distance*pct 

    local max_offset = 150
    local offset = 0

    if pct < 0.5 then
    	offset = pct * max_offset * 2
    else 
    	offset = (1 - pct) * max_offset * 2
    end

    print(offset)

    pos.z = pos.z + offset

    self:GetParent():SetAbsOrigin(pos)

    if pct > 0.9 then
    	self:GetParent():InterruptMotionControllers(true)
    	self:Destroy() 
    end 
end

--------------------------------------------------------------------------------

function modifier_small_satyr_big_jump:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------

function modifier_small_satyr_big_jump:OnDestroy()
    if IsServer() then
	    self:GetParent():InterruptMotionControllers(true)
    end
end
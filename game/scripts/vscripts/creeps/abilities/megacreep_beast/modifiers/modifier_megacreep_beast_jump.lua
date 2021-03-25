modifier_megacreep_beast_jump = class({}) or modifier_megacreep_beast_jump

--------------------------------------------------------------------------------

function modifier_megacreep_beast_jump:IsDebuff() 	return false end
function modifier_megacreep_beast_jump:IsStunned() 	return true end
function modifier_megacreep_beast_jump:IsHidden() 	return true end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_jump:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_jump:CheckState() return 
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_jump:OnCreated(kv)
	if not IsServer() then return end 
	
	self:GetParent():EmitSound("CNY_Beast.Ability.Cast")

	self.target = EntIndexToHScript(kv.target)
	self.duration = kv.duration
	self.startPos = self:GetParent():GetAbsOrigin()
	self.time = 0 
	self.damage = kv.damage 
	self.damage_type = kv.damage_type 

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
function modifier_megacreep_beast_jump:UpdateHorizontalMotion(me, dt)
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

    local dir = (self.target:GetAbsOrigin() - self.startPos)
    local distance = (self.target:GetAbsOrigin() - self.startPos):Length() 

    dir = dir:Normalized()

    local pos = self.startPos + dir*distance*pct 

    self:GetParent():SetAbsOrigin(pos)

    if pct > 0.85 then
    	self:GetParent():InterruptMotionControllers(true)
    	self:Destroy() 
    end 
end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_jump:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_jump:OnDestroy()
    if IsServer() then
    	if self.target and IsValidEntity(self.target) and self.target:IsAlive() then 
	    	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", PATTACH_ABSORIGIN, self.target)
	    	ParticleManager:SetParticleControl(pid, 0, self.target:GetAbsOrigin() )

	    	EmitSoundOn("Hero_Bloodseeker.BloodRite.Cast", self.target)

	    	ApplyDamage({
	    		victim = self.target,
	    		attacker = self:GetParent(),
	    		damage = self.damage,
	    		damage_type = self.damage_type,
	    		ability = self:GetAbility() 
	    	})

	    	self:GetParent():RemoveGesture(ACT_DOTA_NIAN_INTRO_LEAP)
	        self:GetParent():InterruptMotionControllers(true)
	    end 
    end
end
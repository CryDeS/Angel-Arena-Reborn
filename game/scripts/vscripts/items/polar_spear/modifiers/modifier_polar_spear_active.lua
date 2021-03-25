modifier_polar_spear_active = class({})
--------------------------------------------------------------------------------

function modifier_polar_spear_active:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
function modifier_polar_spear_active:GetTexture()
	return "polar_spear"
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:OnCreated( kv )
	if IsServer() then
		self.fSpeed = kv.speed
		self.vPoint = self:GetCaster():GetOrigin() 
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end
end
--------------------------------------------------------------------------------

function modifier_polar_spear_active:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self and self:GetAbility() ~= nil and self:GetParent() ~= nil and self:GetParent():IsAlive() then
			local vParent_point = self:GetParent():GetAbsOrigin()
			if (self.vPoint - vParent_point):Length2D() < 150 then
				GridNav:DestroyTreesAroundPoint(vParent_point, 150, true)
				self:GetParent():InterruptMotionControllers(true) 
			else
				if self:GetParent():IsAlive() then
					self:GetParent():SetAbsOrigin( vParent_point + ((self.vPoint - vParent_point):Normalized() ) * self.fSpeed)
				end
			end

		else 
			self:GetParent():InterruptMotionControllers(true) 
		end
	end
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers(true) 
	end
end

--------------------------------------------------------------------------------

function modifier_polar_spear_active:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
function modifier_polar_spear_active:GetEffectName()
	return "particles/void_stick/void_stick_pull.vpcf"
end
--------------------------------------------------------------------------------
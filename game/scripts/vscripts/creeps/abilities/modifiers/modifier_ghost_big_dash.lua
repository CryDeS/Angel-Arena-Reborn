modifier_ghost_big_dash = class({})
--------------------------------------------------------------------------------

function modifier_ghost_big_dash:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:OnCreated( kv )
	if IsServer() then
		self.fSpeed = kv.speed
		self.vPoint = Vector(kv.point_x, kv.point_y, kv.point_z)
		self.damage = kv.damage
		self.damage_type = kv.damage_type

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
		self.units = {}
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self and self:GetAbility() ~= nil and self:GetParent() ~= nil and self:GetParent():IsAlive() then
			local pos = self:GetParent():GetAbsOrigin()

			local dir = self.vPoint - pos 

			local distance = dir:Length2D() 

			if distance < self.fSpeed then
				self:GetParent():SetAbsOrigin(self.vPoint)
				self:GetParent():InterruptMotionControllers(true)
			else 
				dir = dir:Normalized()
				self:GetParent():SetAbsOrigin(pos + dir*self.fSpeed)
			end

			local units = FindUnitsInRadius(	self:GetParent():GetTeamNumber(), 
												pos, 
												nil, 
												200, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												0, 
												false) 

			if units then
				for i = 1, #units do
					if not self.units[ units[i] ] then
						self.units[units[i]] = 1

						ApplyDamage({ victim = units[i], attacker = self:GetParent(), damage = self.damage, damage_type = self.damage_type })
					end
				end
			end

		else 
			self:GetParent():InterruptMotionControllers(true) 
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_big_dash:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers(true) 
	end
end

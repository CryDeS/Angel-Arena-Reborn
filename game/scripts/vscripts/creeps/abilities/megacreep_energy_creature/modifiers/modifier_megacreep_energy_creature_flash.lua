modifier_megacreep_energy_creature_flash = class({})
--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:IsHidden() 	 	return false end
function modifier_megacreep_energy_creature_flash:RemoveOnDeath() 	return true end
function modifier_megacreep_energy_creature_flash:IsDebuff() 	 	return false end
function modifier_megacreep_energy_creature_flash:IsPurgable() 	 	return false end
function modifier_megacreep_energy_creature_flash:DestroyOnExpire() return true end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:CheckState() return 
{
	[MODIFIER_STATE_INVULNERABLE]   = true,
	[MODIFIER_STATE_MAGIC_IMMUNE]   = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR]  = true,
	[MODIFIER_STATE_OUT_OF_GAME]    = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION]    = true,
} 
end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()

		self.speed 		= kv.speed
		self.targetPos  = Vector(kv.px, kv.py, kv.pz)

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end

		parent:AddNoDraw()
	end
end
--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:UpdateHorizontalMotion( parent, dt )
	if not IsServer() then return end
	if not self then return end
	if not self:GetAbility() then return end

	if not parent then return end

	if not parent:IsAlive() then
		parent:InterruptMotionControllers(true)
		self:Destroy()
	end

	local curPos = parent:GetAbsOrigin() 
	local diff = self.targetPos - curPos
	local diffLen = diff:Length()
	local finished = false

	local dist = self.speed * dt

	if dist > diffLen then
		dist = diffLen
		finished = true
	end

	local velocity = diff:Normalized() * dist

	local newPos = curPos + velocity

	parent:SetAbsOrigin(newPos)

	if finished then
		GridNav:DestroyTreesAroundPoint(newPos, 150, true)
		parent:InterruptMotionControllers(true)
		self:Destroy()
	end
end

function modifier_megacreep_energy_creature_flash:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

modifier_megacreep_energy_creature_flash.UpdateVerticalMotion = modifier_megacreep_energy_creature_flash.UpdateHorizontalMotion
modifier_megacreep_energy_creature_flash.OnVerticalMotionInterrupted = modifier_megacreep_energy_creature_flash.OnHorizontalMotionInterrupted

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers(true)
		self:GetParent():RemoveNoDraw()
	end
end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_flash:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
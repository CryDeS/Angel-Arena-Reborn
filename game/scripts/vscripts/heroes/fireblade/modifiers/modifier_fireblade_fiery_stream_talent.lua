modifier_fireblade_fiery_stream_talent = modifier_fireblade_fiery_stream_talent or class({})
local mod = modifier_fireblade_fiery_stream_talent

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true end


if IsServer() then
	function mod:OnCreated( kv )
		if not IsServer() then return end

		local parent = self:GetParent()

		if not parent then 
			self:Destroy()
			return 
		end

		local pos 		 = Vector(kv.posx, kv.posy, kv.posz)
		local parentPos  = parent:GetAbsOrigin()

		if pos == parentPos then 
			self:Destroy()
			return 
		end

		local dir = (pos - parentPos)

		self.speed 	= kv.speed
		self.dist 	= dir:Length()
		self.dir 	= dir:Normalized()

		parent:SetAbsOrigin( parent:GetAbsOrigin() + self.dir * ( kv.offset or 0 ) )

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end

	function mod:UpdateHorizontalMotion( me, dt )
		if not IsServer() then return end
		if not self then return end

		local parent = me

		if not parent:IsAlive() then
			parent:InterruptMotionControllers(true)
			self:Destroy()
			return
		end

		local distRemain = self.dist

		local wantDist = min(distRemain, dt * self.speed)

		distRemain = distRemain - wantDist

		local newPos = parent:GetAbsOrigin() + self.dir * wantDist
		parent:SetAbsOrigin(newPos)

		self.dist = distRemain

		if distRemain == 0 then
			GridNav:DestroyTreesAroundPoint(newPos, 150, true)
			parent:InterruptMotionControllers(true)
			self:Destroy()
		end
	end

	function mod:OnHorizontalMotionInterrupted()
		self:Destroy()
	end

	function mod:OnDestroy()
		local parent = self:GetParent()

		if parent then
			parent:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
			
			parent:InterruptMotionControllers(true)
		end
	end
end

function mod:CheckState() return
{
	[MODIFIER_STATE_STUNNED] 					= true,
	[MODIFIER_STATE_INVULNERABLE] 				= true,
	[MODIFIER_STATE_OUT_OF_GAME] 				= true,
	[MODIFIER_STATE_NO_HEALTH_BAR] 				= true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] 			= true,
	[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	[MODIFIER_STATE_UNSELECTABLE] 				= true,
	[MODIFIER_STATE_MAGIC_IMMUNE] 				= true,
}
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

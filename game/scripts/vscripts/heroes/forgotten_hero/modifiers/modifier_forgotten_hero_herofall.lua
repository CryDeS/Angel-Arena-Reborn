modifier_forgotten_hero_herofall = modifier_forgotten_hero_herofall or class({})
local mod = modifier_forgotten_hero_herofall

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return false end
function mod:DestroyOnExpire()  return true  end
function mod:IsPurgeException() return true  end

function mod:OnCreated( kv )
	if not IsServer() then return end

	local parent  = self:GetParent()
	local ability = self:GetAbility()

	self.basePos = parent:GetAbsOrigin()
	
	self.height  = ability:GetSpecialValueFor("height") 
	self.speed   = ability:GetSpecialValueFor("speed")
	self.damage  = ability:GetSpecialValueFor("damage")
	self.stunDur = ability:GetSpecialValueFor("stun_duration")

	self.aoe      = ability:GetAOERadius()
	self.aoeTeam  = ability:GetAbilityTargetTeam()
	self.aoeType  = ability:GetAbilityTargetType()
	self.aoeFlags = ability:GetAbilityTargetFlags()
	self.dmgType  = ability:GetAbilityDamageType()

	self.pos     = Vector(kv.px, kv.py, kv.pz)

	self.val 	 = 0

	if (self.basePos - self.pos):Length() < 50 then
		self:Destroy()
		return
	end

	if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
end

function mod:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()

	parent:InterruptMotionControllers(true)

	ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_ABSORIGIN, parent)

	parent:StopSound("Hero_ForgottenHero.Herofall.Cast")
	parent:EmitSound("Hero_ForgottenHero.Herofall.Hit")

	local ability = self:GetAbility()

	local pos = parent:GetAbsOrigin()
	local radius = self.aoe

	local units = FindUnitsInRadius( parent:GetTeamNumber(),
									 pos,
									 parent,
									 radius,
									 self.aoeTeam,
									 self.aoeType,
									 self.aoeFlags,
									 FIND_ANY_ORDER,
									 false )


	GridNav:DestroyTreesAroundPoint(pos, radius, true)

	for _, unit in pairs(units) do
		unit:AddNewModifier(parent, ability, "modifier_forgotten_hero_herofall_debuff", { duration = self.stunDur })

		ApplyDamage({
			victim 		= unit,
			attacker 	= parent,
			damage 		= self.damage,
			damage_type = self.dmgType,
			ability 	= ability,
		})

		if parent:HasTalent("forgotten_hero_talent_herofall_attack") then
			parent:PerformAttack(unit, true, true, true, true, false, false, false)
		end

	end
end

local function lerp(a, b, t)
	return a + t * (b - a)
end

function mod:UpdateHorizontalMotion( parent, dt )
	if not IsServer() then return end
	if not self then return end
	if not self:GetAbility() then return end

	if not parent then return end

	if not parent:IsAlive() then
		parent:InterruptMotionControllers(true)
		self:Destroy()
		return
	end

	local basePos = self.basePos
	local pos = self.pos

	local totalLen = (basePos - pos):Length()

	local newLen = min(self.val + self.speed * dt, totalLen)

	self.val = newLen

	local relVal = newLen / totalLen

	local newHeight = self.height * math.sin( relVal * math.pi )

	local newPos = lerp( basePos, pos, relVal ) + Vector(0, 0, newHeight)

	parent:SetAbsOrigin(newPos)

	if newLen == totalLen then
		parent:InterruptMotionControllers(true)
		self:Destroy()
	end
end

function mod:OnHorizontalMotionInterrupted()
	if not IsServer() then return end

	self:Destroy()
end

mod.UpdateVerticalMotion = mod.UpdateHorizontalMotion
mod.OnVerticalMotionInterrupted = mod.OnHorizontalMotionInterrupted

function mod:DeclareFunctions() return 
{ 
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
} 
end

function mod:GetOverrideAnimation( params )
	return ACT_DOTA_MK_SPRING_SOAR
end

function mod:GetEffectName()
	return "particles/econ/items/monkey_king/arcana/fire/mk_arcana_spring_jump_trail.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
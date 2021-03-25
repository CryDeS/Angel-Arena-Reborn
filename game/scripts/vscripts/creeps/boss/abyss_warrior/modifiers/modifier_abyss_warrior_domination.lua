modifier_abyss_warrior_domination = modifier_abyss_warrior_domination or class({})
local mod = modifier_abyss_warrior_domination

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

function mod:CheckState() return
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

function mod:BaseCreated( kv )
	if not IsServer() then return end

	local ability = self:GetAbility()
	local caster  = self:GetCaster()

	if not ability or not caster then return end

	self.speed 			 = ability:GetSpecialValueFor("pull_speed")
	self.killLimit 		 = ability:GetSpecialValueFor("kill_limit_pct") / 100
	self.disableDuration = ability:GetSpecialValueFor("disable_duration")
	self.casterPos 		 = caster:GetAbsOrigin()
end

function mod:OnCreated( kv )
	self:BaseCreated(kv)

	if not IsServer() then return end
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
end

mod.OnRefresh = mod.BaseCreated

function mod:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	if not self then return end

	local parent = self:GetParent()

	if not parent then return end

	local casterPos = self.casterPos
	local parentPos = parent:GetAbsOrigin()

	if casterPos == parentPos then
		parent:InterruptMotionControllers(true)
		return
	end

	local dir 		= (casterPos - parentPos)
	local distance 	= max(dir:Length() - 150, 0)
	dir 			= dir:Normalized()

	local speed 	= min( distance, dt * self.speed )

	parent:SetAbsOrigin( parentPos + dir * speed )

	if speed == distance or speed == 0 then
		parent:InterruptMotionControllers(true)
	end
end

function mod:OnHorizontalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

function mod:OnDestroy()
	if not IsServer() then return end
	
	local parent = self:GetParent()

	if not parent then return end

	parent:InterruptMotionControllers(true) 
	local hp = parent:GetHealthPercent() / 100

	local ability = self:GetAbility()
	local caster  = self:GetCaster()

	if hp < self.killLimit then
		ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_ABSORIGIN, parent)

		parent:EmitSound("Hero_Warlock.RainOfChaos_buildup")

		parent:Kill(ability, caster)
	else
		parent:EmitSound("Hero_Warlock.FatalBonds")

		parent:AddNewModifier(caster, ability, "modifier_abyss_warrior_domination_debuff", { duration = self.disableDuration })
		
		ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict_disarm_ovrhead_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	end
end

function mod:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd_debuff.vpcf"
end
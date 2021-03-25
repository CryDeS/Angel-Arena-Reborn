modifier_charon_collapse_in_caster = modifier_charon_collapse_in_caster or class({})

local mod = modifier_charon_collapse_in_caster

local START_SOUND   = "Hero_Charon.Collapse.Cast"
local LOOP_SOUND    = "Hero_Charon.Collapse.Loop"
local END_SOUND     = "Hero_Charon.Collapse.End"

--------------------------------------------------------------------------------
function mod:IsHidden()
	return false
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
function mod:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------
function mod:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function mod:OnCreated(kv)
	if not IsServer() then return end
	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	local caster = ability:GetCaster()
	if not caster or caster:IsNull() then return end

	self.radius = ability:GetSpecialValueFor("radius")
	self.damage_per_mana_burn = ability:GetSpecialValueFor("damage_per_mana_burn")
	self.caster_position = caster:GetAbsOrigin()
	local duration_full = ability:GetSpecialValueFor("duration_inside")

	if caster:HasTalent("charon_collapse_bonus_radius_tallent") then
		self.radius = self.radius + caster:GetTalentSpecialValueFor("charon_collapse_bonus_radius_tallent")
	end

	if caster:HasTalent("charon_collapse_bonus_duration_tallent") then
		duration_full = duration_full + caster:GetTalentSpecialValueFor("charon_collapse_bonus_duration_tallent")
	end

	local duration = duration_full

	self.timer1 = Timers:CreateTimer( 0.1, function()
			if not self or self:IsNull() then return end

			if not ability or ability:IsNull() then return end

			if not caster or caster:IsNull() then return end

			duration = duration - 0.1

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
			for _, enemy in pairs(enemies) do
				if enemy and not enemy:IsNull() and IsValidEntity(enemy) and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) and (not (enemy:HasModifier("modifier_charon_collapse_inside"))) then
					local bIsMotionControlled = enemy:IsCurrentlyHorizontalMotionControlled() == true or enemy:IsCurrentlyVerticalMotionControlled() == true
					if not bIsMotionControlled then
						enemy:AddNewModifier(caster, ability, "modifier_charon_collapse_inside", {
							radius = self.radius, 
							duration = duration, 
							duration_full = duration_full,
						})
					end
				end
			end

			return 0.1
		end
	)

	caster:AddNoDraw()

	self.inCasterParticle = ParticleManager:CreateParticle("particles/charon/charon_collapse/charon_collapse_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(self.inCasterParticle, 0, self.caster_position)
	
	EmitSoundOn(START_SOUND, caster)
	EmitSoundOn(LOOP_SOUND, caster)
end

--------------------------------------------------------------------------------
function mod:OnDestroy()
	if not IsServer() then return end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	local caster = ability:GetCaster()
	if not caster or caster:IsNull() then return end

	StopSoundOn(LOOP_SOUND, caster)
	EmitSoundOn(END_SOUND, caster)

	if self.timer1 then
		Timers:RemoveTimer(self.timer1)
		self.timer1 = nil
	end

	if self.inCasterParticle then
		ParticleManager:DestroyParticle(self.inCasterParticle, true)
		self.inCasterParticle = nil
	end

	caster:RemoveNoDraw()

	local particle = ParticleManager:CreateParticle("particles/charon/charon_collapse/charon_collapse_5.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, self.caster_position)

	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	local damageInfo = 	{
		attacker    = caster,
		damage      = ability.all_mana_drain * self.damage_per_mana_burn,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability     = ability,
	}
	
	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and IsValidEntity(enemy) and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then			
			
			Timers:CreateTimer(0.1, function()
				if not enemy or enemy:IsNull() then return end
				if not ability or ability:IsNull() then return end
				
				damageInfo.victim = enemy
				ApplyDamage(damageInfo)
	
				return nil
			end)

			local radius_out = ability:GetSpecialValueFor("radius_out")
			local duration_outside = ability:GetSpecialValueFor("duration_outside")

			local damage_per_mana_burn = self.damage_per_mana_burn
			local allManaDrain = ability.all_mana_drain

			Timers:CreateTimer(0.1, function()
				if not enemy or enemy:IsNull() or not IsValidEntity(enemy) then return end
				if not caster or caster:IsNull() or not IsValidEntity(caster) then return end
				if not ability or ability:IsNull() then return end

				if enemy:IsAlive() then
					enemy:AddNewModifier(caster, ability, "modifier_charon_collapse_outside", {
						radius = radius_out, 
						duration = duration_outside,
						dur = duration_outside,
						point = Vector(self.caster_position.x, self.caster_position.y, self.caster_position.z),
						damage = allManaDrain * damage_per_mana_burn
					})
				end
			end)
		end
	end
end

-------------------------------------------------------------------------------

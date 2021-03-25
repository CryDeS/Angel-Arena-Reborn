soul_guardian_heroes_ring = class({})
local modifierInCaster = "modifier_soul_guardian_heroes_ring_in_caster"
LinkLuaModifier(modifierInCaster, "creeps/boss/soul_guardian/soul_guardian_heroes_ring/"..modifierInCaster, LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
function soul_guardian_heroes_ring:OnSpellStart()
	local base_damage = self:GetSpecialValueFor("base_damage")
	local damage_reduction_per_hero = self:GetSpecialValueFor("damage_reduction_per_hero")
	local circle_radius = self:GetSpecialValueFor("circle_radius")
	local circle_creation_time = self:GetSpecialValueFor("circle_creation_time")
	local detanation_delay = self:GetSpecialValueFor("detanation_delay")

	local caster = self:GetCaster()
	caster.castDamageRingProgress = true
	local particleFirstCircleName = "particles/bosses/soul_guardian/soul_guardian_heroes_ring/soul_guardian_heroes_ring_1.vpcf"
	self.particleFirstCircle = ParticleManager:CreateParticle(particleFirstCircleName, PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControlEnt(self.particleFirstCircle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particleFirstCircle, 1, Vector(circle_radius / circle_creation_time, circle_radius, 1))

	local particleSecondCircleName = "particles/bosses/soul_guardian/soul_guardian_heroes_ring/soul_guardian_heroes_ring_2.vpcf"
	self.particleSecondCircle = ParticleManager:CreateParticle(particleSecondCircleName, PATTACH_ABSORIGIN_FOLLOW, caster)

	local detanationTime = circle_creation_time + detanation_delay
	caster:AddNewModifier( caster, self, modifierInCaster, { duration = detanationTime } )
	
	Timers:CreateTimer(detanationTime, function()
		if not caster:IsAlive() then return end
		ParticleManager:SetParticleControlEnt(self.particleSecondCircle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particleSecondCircle, 1, Vector(circle_radius * 2.5, circle_radius, 1))

		local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, circle_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		local herosInCircle = 0
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsRealHero() then
					herosInCircle = herosInCircle + 1
				end
			end

			herosInCircle = herosInCircle > 1 and herosInCircle - 1 or 0

			for _, enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsRealHero() then

					local damage = base_damage - (damage_reduction_per_hero*herosInCircle)
					local info = {
						victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
						ability = self,
						damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					}
					ApplyDamage(info)
				end
			end
		end
		caster.castDamageRingProgress = false

		Timers:CreateTimer(circle_radius/(circle_radius*2.5)+0.07, function()
			ParticleManager:DestroyParticle(self.particleFirstCircle, false)
			ParticleManager:DestroyParticle(self.particleSecondCircle, false)
			return nil
		end)
		return nil
	end)

end

--------------------------------------------------------------------------------

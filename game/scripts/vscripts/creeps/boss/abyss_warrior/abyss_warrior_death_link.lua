abyss_warrior_death_link = abyss_warrior_death_link or class({})

local ability = abyss_warrior_death_link

LinkLuaModifier( "modifier_abyss_warrior_death_link", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_death_link', LUA_MODIFIER_MOTION_NONE )

function makeParticle(from, to)
	local idx = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, from)

	ParticleManager:SetParticleControlEnt( idx, 0, from, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", from:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt( idx, 1, to, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", to:GetAbsOrigin(), true)
end

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local radius   = self:GetSpecialValueFor("link_radius")
	local duration = self:GetSpecialValueFor("link_duration")

	local targetPos = target:GetAbsOrigin()

	target:TriggerSpellReflect(self)

	if target:TriggerSpellAbsorb(self) then 
		return 
	end

	local units = FindUnitsInRadius( caster:GetTeamNumber(),
									 targetPos,
									 caster,
									 radius,
									 self:GetAbilityTargetTeam(),
									 self:GetAbilityTargetType(),
									 self:GetAbilityTargetFlags(),
									 FIND_ANY_ORDER, 
									 false )

	local nUnits = #units

	makeParticle( caster, target )

	target:EmitSound("Hero_Warlock.FatalBondsDamage")

	if nUnits == 0 then
		return 
	end

	local secondTarget = nil
	local dist = 0

	for _, unit in pairs(units) do
		local unitDist = (targetPos - unit:GetAbsOrigin() ):Length()
		
		if (unitDist < dist or not secondTarget) and unit ~= target then
			dist = unitDist
			secondTarget = unit
		end
	end

	if not secondTarget then return end

	target:AddNewModifier(caster, self, "modifier_abyss_warrior_death_link", { duration = duration }).target = secondTarget
	secondTarget:AddNewModifier(caster, self, "modifier_abyss_warrior_death_link", { duration = duration }).target = target

	makeParticle( target, secondTarget )
end


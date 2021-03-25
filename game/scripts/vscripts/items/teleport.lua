function StartTeleport(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local delay = keys.delay

	if not point then return end

	local friendly_units = FindUnitsInRadius(caster:GetTeamNumber(),
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                              FIND_ANY_ORDER,
                              false)

	local min_distance = 100000;
	local curr_unit = nil;

	for i, x in pairs(friendly_units) do
		if x and x ~= caster and not IsHelpDisabled(x, caster) then
			if min_distance > FindDistance(point, x:GetAbsOrigin()) then
				min_distance = FindDistance(point, x:GetAbsOrigin())
				curr_unit = x;
			end
		end
	end

	if not curr_unit then return end

	ability:ApplyDataDrivenModifier(caster, curr_unit, "modifier_snake_boots_teleport_target", { duration = delay + 0.01})

	local vOrigin = curr_unit:GetAbsOrigin()
	local vCasterOrigin = caster:GetAbsOrigin()

	local VectorBase = Vector(1,0,0)
	local VectorDir = (vOrigin - vCasterOrigin):Normalized()
	local Angle = math.deg( math.acos(VectorBase:Dot( VectorDir:Normalized() )) )

	local vHeroOffset = vOrigin + Vector(0,0,150)
	local vColor = Vector(200, 100, 20)
	local vModelScale = Vector(1.0, 0, 0) -- x here is model scale
	ability.part = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt( ability.part, 0, curr_unit, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt( ability.part, 1, curr_unit, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", Vector(0,0,0), true)
	ParticleManager:SetParticleControl( ability.part, 2, vColor ) -- color of outbounding ring. used for player colors originally
	ParticleManager:SetParticleControlEnt( ability.part, 3, caster, PATTACH_ABSORIGIN, "attach_origin", Vector(0,0,0), false)
	ParticleManager:SetParticleControl( ability.part, 4, vModelScale )
	ParticleManager:SetParticleControl( ability.part, 5, vHeroOffset ) -- model origin, supposed to align with everything

	ability.curr_unit = curr_unit
end

function InterruptTeleport(keys)
	local ability = keys.ability
	local caster = keys.caster

	if not ability.part then return end 

	ParticleManager:DestroyParticle(ability.part, false)
	ParticleManager:ReleaseParticleIndex(ability.part)
	ability.part = nil

	ability.curr_unit:RemoveModifierByNameAndCaster("modifier_snake_boots_teleport_target", caster)
end

function Teleport( keys )
	local caster = keys.caster
	local ability = keys.ability

	if not ability then return end
	if not ability.curr_unit then return end

	local unit = ability.curr_unit

	if ability.part then
    	ParticleManager:DestroyParticle(ability.part, false)
    	ParticleManager:ReleaseParticleIndex(ability.part)
    	ability.part = nil
    end

	local mod = unit:FindModifierByNameAndCaster("modifier_snake_boots_teleport_target", caster)
	if not mod then return end

	point = unit:GetAbsOrigin()
	FindClearSpaceForUnit(caster, point, false)
	caster:Stop()
end

function FindDistance(vec1, vec2)
	return math.sqrt(math.abs(vec1.x - vec2.x)^2 + math.abs(vec1.y - vec2.y)^2 + math.abs(vec1.z - vec2.z)^2 )
end

function IsHelpDisabled(caster, unit)
	local pid1 = caster:GetPlayerOwnerID() 
	local pid2 = unit:GetPlayerOwnerID() 

	if not pid1 or not pid2 or not PlayerResource:IsValidPlayerID(pid1) or not PlayerResource:IsValidPlayerID(pid2) then
		return false
	end

	if PlayerResource:IsDisableHelpSetForPlayerID(pid1, pid2) then
		return true
	end

	return false
end
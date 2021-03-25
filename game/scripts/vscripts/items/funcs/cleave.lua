local illusion_damage_decrease = 1

local forbidden_modifiers = {
	"modifier_pangolier_swashbuckle_stunned",
	"modifier_pangolier_swashbuckle",
	"modifier_pangolier_swashbuckle_attack",
	"modifier_monkey_king_boundless_strike_crit",
}

function CleaveDD(event)
	local caster 			 = event.caster
	local target 			 = event.target
	local damage 			 = event.damage
	local damage_pct 		 = event.dmg_pct / 100
	local radius 			 = event.radius
	local range_hero_allowed = event.range_flag

	if not caster or not target then return end

	if not range_hero_allowed and caster:IsRangedAttacker() then return end
	if caster and caster:IsIllusion() then return end
	
	if not IsValidEntity(caster) or not IsValidEntity(target) then return end
	if not target:IsCreep() and not target:IsHero() then return end 

	for _, modifier_name in pairs(forbidden_modifiers) do
		if caster:HasModifier(modifier_name) then return end 
	end 

	local team = caster:GetTeamNumber()
	local position = target:GetAbsOrigin()

	local units_in_radius = FindUnitsInRadius(	team, 
												position, 
												nil, 
												radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
												0, 
												false)

	if not units_in_radius then return end

	CreateParticleForCleave("particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave_c.vpcf", radius, target)

	for _,x in pairs(units_in_radius) do
		if x ~= target then
			local dmg = damage*damage_pct

			if target:IsIllusion() or x:IsIllusion() then 
				dmg = damage*damage_pct/illusion_damage_decrease
			end

			ApplyDamage({ victim = x, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, ability = event.ability}) --deal damage	
		end
	end
end

-- Вектора направления во все стороны(16 точек по окружности)
local vectors = {
	[0]  = Vector(1.0, 						0.0, 					0.0),
	[1]  = Vector(-0.8733046400935156, 		-0.4871745124605095, 	0.0),
	[2]  = Vector(0.5253219888177297, 		0.8509035245341184, 	0.0),
	[3]  = Vector(-0.04422762066183892, 	-0.999021480034635, 	0.0),
	[4]  = Vector(-0.4480736161291701, 		0.8939966636005579, 	0.0),
	[5]  = Vector(0.8268371568000089, 		-0.562441389066343, 	0.0),
	[6]  = Vector(-0.9960878351411849,		 0.08836868610400143, 	0.0),
	[7]  = Vector(0.9129390999389944, 		0.4080958218391593, 	0.0),
	[8]  = Vector(-0.5984600690578581, 		-0.8011526357338304, 	0.0),
	[9]  = Vector(0.13233681049883225, 		0.9912048065798491, 	0.0),
	[10] = Vector(0.36731936773024515, 		-0.9300948780045254, 	0.0),
	[11] = Vector(-0.7739002269689113, 		0.6333075387972795, 	0.0),
	[12] = Vector(0.9843819506325049, 		-0.1760459464712114, 	0.0),
	[13] = Vector(-0.9454304232544339, 		-0.32582405495135236, 	0.0),
	[14] = Vector(0.6669156003948422, 		0.7451332645574127, 	0.0),
	[15] = Vector(-0.21941055349670321, 	-0.9756326199006828, 	0.0),
}

function CreateParticleForCleave(particle_name, radius, target)	
	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)

	for i = 1, 16 do 
		ParticleManager:SetParticleControl(particle, i, target:GetAbsOrigin() + vectors[i - 1]*radius/2  )
	end 

	ParticleManager:ReleaseParticleIndex( particle )
end


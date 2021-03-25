function OnVolleyAttack(keys)
	local caster 	= keys.caster
	local target 	= keys.target
	local ability 	= keys.ability
	local radius 	= 0
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	if not target then return end
	if ability:GetCooldownTimeRemaining() ~= 0 then return	end
	
	if caster:HasScepter() then
		radius = keys.radius_scepter
	else
		radius = keys.radius
	end

	local position = target:GetAbsOrigin() 
	local team = caster:GetTeamNumber() 
	local units = FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false) 

	if not units then return end
	if #units == 1 then return end

	for i = 1, #units do
		if units[i] ~= target then
			caster:PerformAttack(units[i], false, false, true, false, true, false, false) 
		end
	end
	
	ability:StartCooldown(cooldown) 
end
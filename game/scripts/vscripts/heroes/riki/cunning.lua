function OnCunning( event )
	local caster 		= event.caster
	local ability 		= event.ability
	local target 		= event.target
	local agi_to_dmg 	= ability:GetSpecialValueFor("agi_damage")
	local agility 		= caster:GetAgility() or 0
	local damage 		= agility * agi_to_dmg

	ApplyDamage({
		victim = target,
		attacker = caster, 
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		abilityReturn = ability,
	})

end
function HealOfMaxHealth(event)
	local target 		= event.target
	local caster 		= event.caster
	local heal_percent 	= event.HealPercent or 0

	if not target or not caster or not heal_percent then return end

	local heal 			= caster:GetStrength()*heal_percent / 100

	target:Heal(heal, ability)
end

function DamageOfCurrentHealth(event)
	local caster 		= event.caster
	local target 		= event.target
	local damage_pct 	= event.DamagePercent or 0

	if not target or not damage_pct or not caster then return end

	local damage_total 	= caster:GetStrength()*damage_pct / 100

	ApplyDamage({ victim = target, attacker = caster, damage = damage_total, damage_type = DAMAGE_TYPE_PURE }) 
end


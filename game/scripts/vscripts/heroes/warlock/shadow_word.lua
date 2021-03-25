function HealOfMaxHealth(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heal_pct = event.HealPct / 100
	local heal_const = event.HealConst
	if not caster or not target or not ability then return end

	local heal = caster:GetIntellect()*heal_pct + heal_const
	print('heal = ', heal)
	target:Heal(heal, caster) 
end

function DamageOfMaxHealth(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage_pct = event.HealPct / 100
	local damage_const = event.HealConst

	if not caster or not target or not ability then return end
	local damage = caster:GetIntellect()*damage_pct + damage_const

	print('damage = ', damage)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end
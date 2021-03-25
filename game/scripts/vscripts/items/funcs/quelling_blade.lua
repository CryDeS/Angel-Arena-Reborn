function BonusDamageCreeps(event)
	local caster = event.caster -- attacker
	local target = event.target -- target of attack
	local damage = event.damage -- dealed damage from caster to target
	local bonus_pct = (event.damage_pct - 100) / 100
	local bonus_pct_range = (event.damage_pct_range - 100) / 100
	if not target:IsHero() then
		if caster:IsRangedAttacker() then
			ApplyDamage({ victim = target, attacker = caster, damage = damage*bonus_pct_range,	damage_type = DAMAGE_TYPE_PHYSICAL }) --deal damage
		else
			ApplyDamage({ victim = target, attacker = caster, damage = damage*bonus_pct,	damage_type = DAMAGE_TYPE_PHYSICAL }) --deal damage
		end
	end
end
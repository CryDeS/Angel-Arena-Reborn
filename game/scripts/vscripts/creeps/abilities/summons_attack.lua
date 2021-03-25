function DamageMagical( keys )
	local caster = keys.caster 
	local target = keys.target 

	local damage_pct = (keys.Damage or 0 ) / 100

	if not caster or not target or caster == target then return end
	
	local damage = (caster:GetAverageTrueAttackDamage(target) or 0 ) * damage_pct 

	print("Summon Magical Damage pct:", damage_pct, "damage:", damage)

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end
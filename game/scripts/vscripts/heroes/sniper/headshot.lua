function DamageOfCurrentHealth(event)
	local caster 		= event.caster
	local target 		= event.target
	local damage_pct 	= event.DamagePercent or 0
	local damage 		= event.Damage or 0

	if not target or not caster then return end

	if caster:IsIllusion() then return end
	
	if caster:PassivesDisabled() then return end

	local damage_total 	= (target:GetHealth()*damage_pct / 100 + damage)

	ApplyDamage({ victim = target, attacker = caster, damage = damage_total, damage_type = DAMAGE_TYPE_MAGICAL }) 
end

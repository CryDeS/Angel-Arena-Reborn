function DealDamageOfMaxHealth(event)
	local target = event.target
	local damage_pct = event.damage_pct / 100
	local caster = event.caster
	if not target or not damage_pct or not caster then return end

	local damage_total = target:GetMaxHealth()*damage_pct 
	--print('damage = ', damage_total)
	ApplyDamage({ victim = target, attacker = caster, damage = damage_total,	damage_type = DAMAGE_TYPE_MAGICAL }) 
end

function DealDamageOfCurrentHealth(event)
	local target = event.target
	local damage_pct = event.damage_pct / 100
	local caster = event.caster
	if not target or not damage_pct or not caster then return end

	local damage_total = target:GetHealth()*damage_pct 
	--print('damage = ', damage_total)
	ApplyDamage({ victim = target, attacker = caster, damage = damage_total,	damage_type = DAMAGE_TYPE_MAGICAL }) 
end


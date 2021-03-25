function DamagePct( keys )
	local caster 	= keys.caster
	local target	= keys.target
	local ability 	= keys.ability
	local dmg_pct	= keys.DamagePct / 100

	if caster:PassivesDisabled() then return end

	local damage = target:GetHealth() * dmg_pct

	ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL }) 
end
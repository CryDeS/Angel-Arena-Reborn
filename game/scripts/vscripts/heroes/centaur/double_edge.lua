function OnDoubleEdgeStart( keys )
	local caster	= keys.caster
	local target  	= keys.target
	local particle 	= ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow

	local damage = Util:DisableSpellAmp( caster, keys.Damage )

	ApplyDamage({victim = caster, attacker = caster,
				 damage = damage , damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL})

	print(keys.Damage)
end
	
function DoubleEdgeDamage( keys )
	local damage = (keys.Damage + Util:DisableSpellAmp(  keys.caster, keys.caster:GetStrength() * keys.DamagePct / 100 ) )

	ApplyDamage({victim = keys.target, attacker = keys.caster,
				 damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	print(keys.Damage)
end
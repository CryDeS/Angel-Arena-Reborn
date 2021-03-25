function SoulBurnStart( keys )
	local caster 		= keys.caster 
	local target 		= keys.target
	local damage 		= keys.Damage 
	local damage_pct 	= keys.DamagePct / 100
	local modifier_name = keys.ModifierName

	local soul_count = caster:GetModifierStackCount(modifier_name, caster) or 0

	local damage = damage*soul_count + damage_pct * target:GetMaxHealth()

	caster:RemoveModifierByName(modifier_name)

	if BossSpawner:IsBoss(target) then
		damage = damage / 5
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end

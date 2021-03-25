function ManaBreak( keys )
	local caster 			= keys.caster
	local target 			= keys.target
	local dmg_per_mana 		= keys.damage_per_mana / 100
	
	if target:GetMana() == 0 then return end
	if target:IsMagicImmune() then return end

	local mana_burn 		= keys.mana_per_hit + (target:GetMaxMana()*keys.mana_pct_per_hit / 100)

	if (mana_burn > target:GetMana()) then mana_burn = target:GetMana() end

	local damage = mana_burn*dmg_per_mana

	target:ReduceMana(mana_burn)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	print("mana break damage = ", dmg_per_mana*mana_burn, "mana burned = ", mana_burn)
	
end
function HealPct(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local heal_pct = keys.HealPct/100
	local total_heal = target:GetMaxHealth()*heal_pct
	target:Heal(total_heal, ability) 
	print(total_heal)
end
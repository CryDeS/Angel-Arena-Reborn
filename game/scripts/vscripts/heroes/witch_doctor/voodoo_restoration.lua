function Heal( keys )
	local caster 	= keys.caster
	local ability 	= keys.ability
	local target 	= keys.target
	local pct 		= ability:GetSpecialValueFor("heal_percent") + caster:GetTalentSpecialValueFor("special_bonus_unique_witch_doctor_2") 

	local heal 		= ( ability:GetSpecialValueFor("heal")
						+  target:GetMaxHealth()*pct  / 100 ) / 3
	target:Heal(heal, ability)

end
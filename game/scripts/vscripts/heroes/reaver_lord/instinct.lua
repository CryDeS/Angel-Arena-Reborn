function OnAttackStart( keys )
	local caster 					= keys.caster
	local target 					= keys.target
	local soul_modifier_name 		= keys.ModifierNameSoul
	local damage_modifier_name 		= keys.ModifierNameDamage
	local lfiesteal_modifier_name 	= keys.ModifierNameLifesteal
	local ability 					= keys.ability

	if caster:GetHealth() / caster:GetMaxHealth()  < target:GetHealth() / target:GetMaxHealth() then
		caster:RemoveModifierByName(damage_modifier_name)
		caster:RemoveModifierByName(lfiesteal_modifier_name)
		return 
	end

	local souls_count = caster:GetModifierStackCount(soul_modifier_name, caster) or 0

	if souls_count > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, damage_modifier_name, {})
		ability:ApplyDataDrivenModifier(caster, caster, lfiesteal_modifier_name, {})
		caster:SetModifierStackCount(damage_modifier_name, caster, souls_count)
	end

end
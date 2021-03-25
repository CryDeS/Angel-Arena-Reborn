function DoubleDiffusialBlades(keys)
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local modifier_name = keys.ModifierName

	if not ability or not target or not caster then return end
	
	if target:GetTeam() == caster:GetTeam() then
		target:Purge(false, true, false, true, false )
		while(target:HasModifier("modifier_huskar_burning_spear_counter")) do
			target:RemoveModifierByName("modifier_huskar_burning_spear_counter")
		end
		target:RemoveModifierByName("modifier_huskar_burning_spear_debuff")
		target:RemoveModifierByName("modifier_dazzle_weave_armor")
		target:RemoveModifierByName("modifier_dazzle_weave_armor_debuff")
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
		target:Purge(true, false, false, false, false )
		target:RemoveModifierByName("modifier_omniknight_guardian_angel")
		target:RemoveModifierByName("modifier_omninight_guardian_angel")
		target:RemoveModifierByName("modifier_omniknight_repel")
		target:RemoveModifierByName("modifier_dazzle_weave_armor_debuff")
		target:RemoveModifierByName("modifier_dazzle_weave_armor")
	end

end

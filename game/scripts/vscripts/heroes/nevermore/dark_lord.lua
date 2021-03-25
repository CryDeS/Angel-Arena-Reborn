function Disarmor( keys )
	local caster 		= keys.caster
	local target 		= keys.target
	local ability		= keys.ability
	local modifier_name = keys.ModifierName 
	local disarmor 		= math.abs(keys.Disarmor_const) or 0
	local disarmor_pct 	= (keys.Disarmor_pct / 100 ) or 0
	if caster:PassivesDisabled() then 
		target:RemoveModifierByName(modifier_name)
		return 
	end
	
	disarmor = disarmor - caster:GetTalentSpecialValueFor("special_bonus_unique_nevermore_5") 

	local total_disarmor = target:GetPhysicalArmorValue( false ) *disarmor_pct + disarmor

	if not target:HasModifier(modifier_name) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_name, {}) 
	end
	
	local stack_count = target:GetModifierStackCount(modifier_name, caster)
	if total_disarmor < stack_count then total_disarmor = stack_count end

	target:SetModifierStackCount(modifier_name, caster, total_disarmor)
end

function CheckAura( keys )
	local target = keys.target
	local modifier_name = keys.ModifierName
	local modifier_remove = keys.ModifierRemove

	if not target:HasModifier(modifier_name) then
		target:RemoveModifierByName(modifier_remove)
	end
end
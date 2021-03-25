function CheckHealth(event)
	local caster = event.caster
	local ability = event.ability
	local modifier_name_70 = event.modifier_70
	local modifier_name_50 = event.modifier_50
	local modifier_name_25 = event.modifier_25

	if not caster or not ability then return end

	local health = caster:GetHealth() 
	local max_health = caster:GetMaxHealth() 

	if not caster:HasModifier(modifier_name_70) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_name_70, nil) 
	end
	
	if health/max_health < 0.5 then
		if not caster:HasModifier(modifier_name_50) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_name_50, nil) 
		end
	else
		caster:RemoveModifierByName(modifier_name_50)
	end

	if health/max_health < 0.25 then
		if not caster:HasModifier(modifier_name_25) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_name_25, nil) 
		end
	else
		caster:RemoveModifierByName(modifier_name_25)
	end
end

function CheckIlussion(event)
	local caster = event.attacker

	if not caster then end
	
	if caster:IsIllusion() then
		caster:ForceKill(true)
	end
end
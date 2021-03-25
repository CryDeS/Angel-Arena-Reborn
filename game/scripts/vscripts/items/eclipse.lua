function OnSpellStart(event) 
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = event.Duration
	if target:HasModifier("modifier_eclipse_amphora_cooldown") then return end 
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_eclipse_amphora", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_eclipse_amphora_cooldown", {duration = 25})
end
local forbidden_modifiers_list = {
	"modifier_sniper_machine_gun",
}

function HasForbiddenModifier(unit)
	for _, modifier_name in pairs(forbidden_modifiers_list) do
		if unit:HasModifier(modifier_name) then 
			return true 
		end
	end

	return false
end

function Bash(keys)
	local caster 			= keys.caster
	local target 			= keys.target
	local ability 			= keys.ability
	local modifier_name 	= keys.ModifierName
	local cooldown			= keys.Cooldown or 0
	local cooldown_modifier = keys.CooldownModifier

	if caster:IsIllusion() or not modifier_name then return end
	if cooldown_modifier and caster:HasModifier(cooldown_modifier) then return end
	if HasForbiddenModifier(caster) then return end
	if BossSpawner:IsBoss(target) then return end 
	
	if not ability:IsItem() then 
		if caster:PassivesDisabled() then 
			return 
		end
	end
	
	if cooldown_modifier then
		ability:ApplyDataDrivenModifier(caster, caster, cooldown_modifier, { duration = cooldown })
	end

	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
end
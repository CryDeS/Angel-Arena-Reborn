function OnAttackLanded( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local target 			= keys.target
	local attack_per_soul 	= keys.AttacksToHero
	local modifier_name		= keys.ModifierName 
	local duration 			= keys.Duration
	local max_stack 		= keys.MaxStack
	
	if caster:PassivesDisabled() then return end

	ability.attacks_to_hero = ability.attacks_to_hero or 0

	if not target:IsRealHero() then return end

	ability.attacks_to_hero = ability.attacks_to_hero + 1

	if ability.attacks_to_hero >= attack_per_soul then
		ability.attacks_to_hero = 0
		_IncreaseSoulStack(caster, ability, modifier_name, duration, max_stack)
	end
end

function OnKill( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local target 			= keys.unit
	local modifier_name		= keys.ModifierName 
	local duration 			= keys.Duration
	local creep_to_soul		= keys.CreepsToSoul
	local soul_by_hero 		= keys.SoulByHero
	local max_stack 		= keys.MaxStack

	if caster:PassivesDisabled() then return end

	if not target then print("NIL TARGET ONKILL"); return end
	ability.creeps_killed = ability.creeps_killed or 0
	if target:IsRealHero() then
		_IncreaseSoulStack(caster, ability,modifier_name, duration, max_stack)
		return;
	end

	ability.creeps_killed = ability.creeps_killed + 1

	if ability.creeps_killed >= creep_to_soul then
		print("creeps killed = ", ability.creeps_killed, " creep to soul = ", creep_to_soul)
		_IncreaseSoulStack(caster, ability,modifier_name, duration, max_stack)
		ability.creeps_killed = 0
		return;
	end

end

function _IncreaseSoulStack(caster, ability, soul_modifier_name, duration, max_stack)
	local stacks = caster:GetModifierStackCount(soul_modifier_name, caster) or 0

	caster:RemoveModifierByName(soul_modifier_name)
	ability:ApplyDataDrivenModifier(caster, caster, soul_modifier_name, {duration = duration})
	if stacks == max_stack then
		caster:SetModifierStackCount(soul_modifier_name, caster, stacks)
		return
	end

	caster:SetModifierStackCount(soul_modifier_name, caster, stacks + 1)
end

function OnCreated( keys )
	local caster = keys.caster
	local ability = keys.ability 
	caster.soul_ability = ability
end
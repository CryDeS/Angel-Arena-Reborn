function OnTakeDamagePASSIVE( keys )
	local ability = keys.ability 

	ability:StartCooldown(15.0)
end

function OnTakeDamage( keys )
	local ability = keys.ability 

	if ability:GetCooldownTimeRemaining() ~= 0 then return end

	ability.attacks = ability.attacks or 0

	ability.attacks = ability.attacks + 1

	print("DAMAGE ATTACK!")

	if ability.attacks >= ability:GetSpecialValueFor("attack_count") then
		keys.caster:RemoveModifierByName("modifier_boss_stoneform_regen")
		ability.attacks = 0
		ability:StartCooldown(15.0)
	end
end

function IntervalThink( keys )
	local ability = keys.ability 
	local caster = keys.caster 

	if ability:GetCooldownTimeRemaining() == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_stoneform_regen", {duration = 2})
	end
end
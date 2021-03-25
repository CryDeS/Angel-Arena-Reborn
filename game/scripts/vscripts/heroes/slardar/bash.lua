function CheckIllusion( keys )
	local caster = keys.caster

	if caster:IsIllusion() then
		while caster:HasModifier("modifier_slardar_basher") do
			caster:RemoveModifierByName("modifier_slardar_basher")
		end
	end
	
end

function ApplyBash( keys )
	local caster 			= keys.caster
	local target 			= keys.target
	local ability 			= keys.ability 
	local modifier_name 	= keys.ModifierName 
	local duration 			= keys.duration

	if not target:IsHero() then duration = keys.duration_creep end


	if ability:GetCooldownTimeRemaining() ~= 0 then return end

	local cooldown 	= ability:GetCooldown(ability:GetLevel())
	
	ability:StartCooldown(cooldown)

	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {duration = duration}) 
end
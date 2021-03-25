function OnAttack( keys )
	local ability 			= keys.ability
	local caster 			= keys.caster
	local target 			= keys.target
	local disarmor 			= keys.Disarmor / 100
	local modifier_name 	= keys.ModifierName
	local duration 			= keys.Duration
	local max_disarmor_pct 	= keys.MaxDisarmor / 100
	local disarmor_const 	= keys.DisarmorConst or 0
	if caster:IsIllusion() then return end

	if ability:GetCooldownTimeRemaining() ~= 0 then return end

	ability:StartCooldown(ability:GetCooldown(1))
	
	local stack_count 			= target:GetModifierStackCount(modifier_name, caster) or 0
	local target_armor_total 	= target:GetPhysicalArmorValue( false ) + stack_count

	disarmor = disarmor * target_armor_total + disarmor_const

	ability:ApplyDataDrivenModifier(caster, target, modifier_name, { duration = duration })
	if stack_count < max_disarmor_pct*target_armor_total then
		target:SetModifierStackCount(modifier_name, caster, stack_count + disarmor)
	end
	--if target:HasModifier(modifier_name) then
	--	if stack_count < max_disarmor_pct*target_armor_total then
			--ability:ApplyDataDrivenModifier(caster, target, modifier_name, { duration = duration })
	--		target:SetModifierStackCount(modifier_name, caster, stack_count + disarmor)
--		end
--	else
--		--ability:ApplyDataDrivenModifier(caster, target, modifier_name, { duration = duration })
--		target:SetModifierStackCount(modifier_name, caster, disarmor)
--	end
end
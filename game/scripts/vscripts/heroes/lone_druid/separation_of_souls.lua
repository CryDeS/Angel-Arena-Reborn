function OnIntervalThink(event)
	local caster = event.caster
	local ability = event.ability
	if not caster or not ability then end

	local modifier_attack = event.modifier_attack -- 10 attack per stack
	local modifier_armor  = event.modifier_armor  -- 1 armor per stack
	local modifier_aspeed = event.modifier_aspeed -- 10 aspeed per stack

	local bonus_attack_pct = event.bonus_attack_pct / 100
	local bonus_armor_pct  = event.bonus_armor_pct  / 100
	local bonus_aspeed_pct = event.bonus_aspeed_pct / 100

	local owner = caster:GetPlayerOwner():GetAssignedHero() 

	local attack_stack = (owner:GetAverageTrueAttackDamage(nil) * bonus_attack_pct) / 10
	local armor_stack  = (owner:GetPhysicalArmorValue( false ) * bonus_armor_pct)
	local aspeed_stack = (owner:GetAttackSpeed()*100 * bonus_aspeed_pct) / 10

	caster:RemoveModifierByName(modifier_attack)
	caster:RemoveModifierByName(modifier_armor)
	caster:RemoveModifierByName(modifier_aspeed)


	if not caster:HasModifier(modifier_attack) and attack_stack > 1 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_attack, { duration = -1 }) 
		caster:SetModifierStackCount(modifier_attack, caster, attack_stack)
	end
	

	if not caster:HasModifier(modifier_armor) and armor_stack > 1 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_armor, { duration = -1 }) 
		caster:SetModifierStackCount(modifier_armor, caster, armor_stack)
	end
	

	if not caster:HasModifier(modifier_aspeed) and aspeed_stack > 1 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aspeed, { duration = -1 }) 
		caster:SetModifierStackCount(modifier_aspeed, caster, aspeed_stack)
	end
end

function OnDestroy(event)
	local caster = event.caster
	local ability = event.ability
	if not caster or not ability then end

	local modifier_attack = event.modifier_attack -- 10 attack per stack
	local modifier_armor  = event.modifier_armor  -- 2 armor per stack
	local modifier_aspeed = event.modifier_aspeed -- 10 aspeed per stack

end
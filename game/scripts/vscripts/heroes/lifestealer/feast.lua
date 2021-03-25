function OnAttack(event)
	local ability	= event.ability
	local target 	= event.target
	local heal_pct 	= event.heal_pct	or 0
	local caster 	= event.caster

	if caster:IsIllusion() or target:IsIllusion() then return end
	if caster:PassivesDisabled() then return end

	heal_pct = heal_pct + caster:GetTalentSpecialValueFor("special_bonus_unique_lifestealer_3")
	
	local damage = target:GetMaxHealth() * heal_pct / 100

	local armor_effictivity = 0.5

	local armor_value = target:GetPhysicalArmorValue( false )
	
	local armor = ( (0.06 * armor_value ) / ( 1+ 0.06 * math.abs(armor_value) ) )

	armor = armor * armor_effictivity

	if armor < 0 then armor = 0 end

	local heal = damage - damage*armor

	if (target:GetPhysicalArmorValue( false ) < 0) then
		heal = damage;
	end

	if heal < 1 or damage < 1 then return end

	ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_PHYSICAL })

	caster:Heal(heal / 4, caster)
end
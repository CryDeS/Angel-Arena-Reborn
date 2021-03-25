local forbidden_refresh = {
	["item_refresher"] 					= 1,
	["item_recovery_orb"]				= 1,	
	["spike_conclusion"]				= 1,	
}

function ForEveryAbility( caster, functor )
	for i = 0, caster:GetAbilityCount() - 1 do
		functor( caster:GetAbilityByIndex(i) )
	end

	for i = 0, 12 do
		functor( caster:GetItemInSlot(i) )
	end

	-- TP Slot
	functor( caster:GetItemInSlot(15) )

	-- neutral slot
	functor( caster:GetItemInSlot(16) )
end

function OnSpellStart( keys ) 
	local caster = keys.caster
	local selfAbility = keys.ability

	caster:Purge( false, true, false, true, false )

	while(caster:HasModifier("modifier_huskar_burning_spear_counter")) do
		caster:RemoveModifierByName("modifier_huskar_burning_spear_counter")
	end

	caster:RemoveModifierByName("modifier_huskar_burning_spear_debuff")
	caster:RemoveModifierByName("modifier_dazzle_weave_armor")
	caster:RemoveModifierByName("modifier_dazzle_weave_armor_debuff")

	selfAbility.list = {}
	selfAbility.startTime = GameRules:GetGameTime()


	local subrefresh = function(ability)
		if not ability then return end

		local name = ability:GetName()

		if forbidden_refresh[ name ] then return end

		local cd = ability:GetCooldownTimeRemaining()

		if cd > 0 then
			selfAbility.list[name] = cd
		end

		ability:RefreshCharges()
		ability:EndCooldown()	
	end

	ForEveryAbility( caster, subrefresh )
end

function Active_OnDestroy( keys )
	local caster = keys.caster 
	local selfAbility = keys.ability 

	local timeDiff = GameRules:GetGameTime() - selfAbility.startTime

	local revertCooldown = function(ability)
		if not ability then return end

		local cd = ability:GetCooldownTimeRemaining()

		if cd > 0 then return end

		local newCd = selfAbility.list[ ability:GetName() ]

		if newCd == nil then return end

		newCd = max(0, newCd - timeDiff)

		if newCd > 0 then
			ability:StartCooldown(newCd)
		end
	end

	ForEveryAbility( caster, revertCooldown )
end

function Active_CooldownIncrease( keys )
	local caster = keys.caster
	local ability = keys.event_ability
	local multipler = keys.Multipler / 100

	local wantCd = ability:GetCooldown(ability:GetLevel() - 1) * caster:GetCooldownReduction()

	wantCd = wantCd * multipler

	ability:EndCooldown() 
	ability:StartCooldown(wantCd)
end

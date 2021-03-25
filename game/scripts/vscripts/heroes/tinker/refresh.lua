local non_refreshable = {
	["item_black_king_bar"] = 1,
	["item_hand_of_midas"] = 1,
	["item_advanced_midas"] = 1,
	["item_necronomicon"] = 1,
	["item_necronomicon_2"] = 1,
	["item_necronomicon_3"] = 1,
	["item_black_king_bar"] = 1,
	["item_refresher"] = 1,
	["item_sphere"] = 1,
	["item_sphere_2"] = 1,
	["item_helm_of_the_dominator"] = 1,
	["item_arcane_boots"] = 1,
	["item_strange_amulet"] = 1,
	["item_mystic_amulet"] = 1,
	["item_power_amulet"] = 1,
	["item_kings_bar"] = 1,
	["item_octarine_core_2"] = 1,
	--["item_snake_boots"] = 1,
	["item_recovery_orb"]	= 1,
	["item_potion_immune"] = 1,
	["item_aeon_disk"] = 1,
	["item_aegis_aa"] = 1,
	["item_ex_machina"] = 1,
	["item_trusty_shovel"]	= 1,
	["item_shard_hola"]	= 1,
	["item_shard_huntress"]	= 1,
	["item_shard_joe_black"]	= 1,
	["item_shard_satan"]	= 1,
}



function _refresh(ability)
	if ability and not non_refreshable[ability:GetName()] then
		ability:RefreshCharges()
		ability:EndCooldown()
	end
end 

function Refresh(keys)
	local caster 	= keys.caster
	local ability 	= keys.ability


	for i = 0, caster:GetAbilityCount() - 1 do
		_refresh( caster:GetAbilityByIndex(i) )

	end

	for i = 0, 12 do
		_refresh(caster:GetItemInSlot(i))
	end

	-- TP Slot
	_refresh(caster:GetItemInSlot(15))

	-- neutral slot
	_refresh(caster:GetItemInSlot(16))
end

function Refresh_tinker_animation( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	
	if abilityLevel > 3 then
		abilityLevel = 3 
	end 

	ability:ApplyDataDrivenModifier( caster, caster, "modifier_tinker_rearm_level_" .. abilityLevel, {} )
end
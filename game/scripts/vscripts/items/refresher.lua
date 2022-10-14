local non_refreshable = {
	--["omniknight_protection_of_god"] 	= 1,
	["item_refresher"] 					= 1,
	["angel_arena_transmute"]			= 1,
	["item_recovery_orb"]				= 1,
	["item_pet_hulk"] 					= 1,
	["item_pet_mage"] 					= 1,
	["item_pet_wolf"] 					= 1,
	["spike_conclusion"] 				= 1,
	["item_aegis_aa"]					= 1,
	["item_ex_machina"]					= 1,
	["dazzle_good_juju"]				= 1,

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
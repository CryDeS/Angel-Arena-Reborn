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

local passive_used = {}

local DOTA_ABILITY_TYPE_ULTIMATE = 1

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

function PassiveRefresh( keys )
	local caster 			= keys.caster
	local chance_ability 	= keys.ChanceAbility 
	local chance_ultimate 	= keys.ChanceUltimate 
	local ability 			= keys.event_ability

	if not ability then return end
	
	if ability == keys.ability then return end 

	local ability_type = ability:GetAbilityType()

	if ability_type == DOTA_ABILITY_TYPE_ULTIMATE then
		chance_ability = chance_ultimate
	end
	
	passive_used[ability] = passive_used[ability] or 0

	passive_used[ability] = passive_used[ability] - 1
	if RollPercentage(chance_ability) then
		if passive_used[ability] <= 0 then
			local cooldownThis = ability:GetCooldownTime()/100*50
			ability:EndCooldown()
			ability:StartCooldown(cooldownThis)
			passive_used[ability] = 2
			local particleAgi = ParticleManager:CreateParticle("particles/items/recovery_orb/recovery_orb_passive_proc/recovery_orb_passive_proc.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(particleAgi, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particleAgi, 2, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particleAgi, 4, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		end
	end
	
end

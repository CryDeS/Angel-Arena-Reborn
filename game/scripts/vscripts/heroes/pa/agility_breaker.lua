function OnIntervalThink(keys)
	local player_id = keys.caster:GetPlayerOwnerID() 
	local stack_count = PlayerResource:GetKills(player_id)-- + PlayerResource:GetAssists(player_id) 

	if not keys.caster:HasModifier(keys.ModifierName) then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, keys.ModifierName, {})
	end

	keys.caster:SetModifierStackCount( keys.ModifierName, keys.ability, stack_count)
end

function OnUpgrade(keys)
	local player_id = keys.caster:GetPlayerOwnerID() 
	local stack_count = PlayerResource:GetKills(player_id)
	keys.caster:RemoveModifierByName(keys.ModifierName)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, keys.ModifierName, {})
	keys.caster:SetModifierStackCount( keys.ModifierName, keys.ability, stack_count)
end
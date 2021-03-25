local sabres = {
	["item_echo_sabre"] = 1,
	["item_echo_sabre_2"] = 1,
	["item_echo_sabre_3"] = 1,	
}

function EchoSabreAttack(keys)
	--[[local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_name = keys.ModifierName
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
]]
	if keys.caster:IsRangedAttacker() then return end
	if keys.caster:IsIllusion() then return end

	if keys.ability:GetCooldownTimeRemaining() ~= 0 then return end

	local first_item = -1;

	for i = 0, 5 do
		local item = keys.caster:GetItemInSlot(i)
		if item and sabres[item:GetName()]then
			if(first_item == -1) then
				first_item = i;
			end
		end
	end

	if keys.caster:GetItemInSlot(first_item) ~= keys.ability then return end

	keys.ability:StartCooldown(keys.ability:GetCooldown(keys.ability:GetLevel() - 1))
	Timers:CreateTimer(0.1, function()
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, keys.ModifierName, {})
		keys.caster:PerformAttack(keys.target, true, true, true, true, true, false, false) 
	end)
end
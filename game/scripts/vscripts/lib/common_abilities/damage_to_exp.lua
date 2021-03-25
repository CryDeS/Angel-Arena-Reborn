LinkLuaModifier("modifier_damage_to_exp_cd", 'lib/common_abilities/modifiers/modifier_damage_to_exp_cd', LUA_MODIFIER_MOTION_NONE)

require('lib/common_abilities/base')

CommonAbilities.DamageToExp = CommonAbilities.DamageToExp or class({})

local subclass = CommonAbilities.DamageToExp

function subclass:CommonInitDamageToExp(ability, optionalCD)
	if not IsServer() then return end

	self:InitDamageToExp( ability:GetSpecialValueFor("damage_to_exp_ranged"),
						  ability:GetSpecialValueFor("damage_to_exp_melee"),
						  ability:GetSpecialValueFor("min_exp_melee"),
						  ability:GetSpecialValueFor("min_exp_ranged"),
						  optionalCD or ability:GetSpecialValueFor("exp_cooldown") )
end

function subclass:InitDamageToExp( damageRanged, damageMelee, minMelee, minRanged, cooldown )
	self.DamageToExp = {
		damageRanged 	= damageRanged / 100,
		damageMelee 	= damageMelee  / 100,
		minMelee 		= minMelee,
		minRanged 		= minRanged,
		cooldown 		= cooldown,
	}
end

function subclass:ProcessDamageToExp(parent, ability, damage)
	if not parent:IsRealHero() or not parent:IsAlive() or parent:IsTempestDouble() then return false end

	if damage < 1 then return false end

	local dataTable = self.DamageToExp

	local cd = dataTable.cooldown

	if cd ~= 0 and parent:HasModifier("modifier_damage_to_exp_cd") then return false end

	local isRanged = parent:IsRangedAttacker()

	local damageMod = dataTable.damageMelee
	local minExp 	= dataTable.minMelee

	if isRanged then
		damageMod = dataTable.damageRanged
		minExp 	= dataTable.minRanged
	end

	local exp = max(minExp, damage * damageMod)

	parent:AddExperience(exp, 0, true, true) 

	if cd ~= 0 then
		parent:AddNewModifier(parent, ability, "modifier_damage_to_exp_cd", { duration = cd * parent:GetCooldownReduction() }) 
	end

	return true
end

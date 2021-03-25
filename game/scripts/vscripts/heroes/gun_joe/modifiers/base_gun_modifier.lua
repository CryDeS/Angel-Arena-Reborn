local _base_gun_modifier = _base_gun_modifier or {}

local mod = _base_gun_modifier

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:OnCreated( kv )
	if not self or self:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.bat 			= ability:GetSpecialValueFor(self.batName)
	self.damageModifier = ability:GetSpecialValueFor(self.damageModifierName)
	self.rangeBonus		= ability:GetSpecialValueFor(self.rangeBonusName)
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
}
end

function mod:GetModifierAttackRangeBonus()
	return self.rangeBonus
end

function mod:GetModifierBaseAttackTimeConstant()
	return self.bat
end

function mod:GetModifierTotalDamageOutgoing_Percentage()
	return self.damageModifier
end

function MakeBaseGunModifier( rangeBonusName, batName, damageModifierName )
	local result = class({})

	for i,x in pairs(mod) do
		result[i] = x
	end

	result.batName 			  = batName
	result.damageModifierName = damageModifierName
	result.rangeBonusName 	  = rangeBonusName

	return result
end
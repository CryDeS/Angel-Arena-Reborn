modifier_shadowshaman_wards = class({})

function modifier_shadowshaman_wards:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
 
	return funcs
end

function modifier_shadowshaman_wards:IsHidden()
	return true
end

function modifier_shadowshaman_wards:IsPurgable()
	return false
end

function modifier_shadowshaman_wards:GetModifierExtraHealthBonus(params)
	local time = GameRules:GetGameTime() / 60

	if time < 15 then return 0 end

	return math.ceil((time - 15) / 7 )
end

function modifier_shadowshaman_wards:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60

	if time < 15 then return 0 end

	return ((time - 15) / 5) * 40
end

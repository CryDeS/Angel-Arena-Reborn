modifier_witch_doctor_ward = class({})

function modifier_witch_doctor_ward:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
 
	return funcs
end

function modifier_witch_doctor_ward:IsHidden()
	return true
end

function modifier_witch_doctor_ward:IsPurgable()
	return false
end

function modifier_witch_doctor_ward:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60

	if time < 40 then
		return 0.0354*math.pow(time,2) - 0.03*time
	else
		return 0.12*math.pow(time,2) - 0.03*time
	end
end
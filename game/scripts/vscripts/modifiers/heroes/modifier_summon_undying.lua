modifier_summon_undying = class({})

function modifier_summon_undying:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_summon_undying:IsHidden()
	return true
end

function modifier_summon_undying:IsPurgable()
	return false
end

function modifier_summon_undying:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60

	return 0.176*math.pow(time,2) - 0.03*time
end

function modifier_summon_undying:GetModifierAttackSpeedBonus_Constant(params)
	local time = GameRules:GetGameTime() / 60
	local attack_speed = 0.029*math.pow(time,2) + 2.66*time - 20
	
	if attack_speed < 0 then attack_speed = 0 end

	return attack_speed
end

function modifier_summon_undying:GetModifierPhysicalArmorBonus(params)
	local time = GameRules:GetGameTime() / 60
	local armor = math.pow(math.sqrt(time - 15), (2.718*0.88))
	
	if time < 15 then armor = 0 end -- caused by sqrt(-15)

	return armor
end

function modifier_summon_undying:OnCreated(event)
end
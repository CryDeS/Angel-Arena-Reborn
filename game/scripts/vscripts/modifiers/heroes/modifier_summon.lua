modifier_summon = class({})

function modifier_summon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

function modifier_summon:IsHidden()
	return true
end

function modifier_summon:IsPurgable()
	return false
end

function modifier_summon:GetModifierExtraHealthBonus(params)
	local time = GameRules:GetGameTime() / 60

	local delitel = (time / 60) * (time / 60) * 20
	if time < 60 then delitel = time/2 end
	
	local bonus_health = (3.69613*math.pow((time + 30),1.7) - 60.7182*(time + 30) + 429)* (time/delitel) 
	
	if bonus_health < 0 then bonus_health = 0 end

	return bonus_health
end

function modifier_summon:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60


	--return math.abs(0.0984*math.pow(time,2) + 5.49*time - 30)
	if time < 40 then
		return 0.0454*math.pow(time,2) - 0.03*time
	else
		return 0.106*math.pow(time,2) - 0.03*time
	end
end

function modifier_summon:GetModifierAttackSpeedBonus_Constant(params)
	local time = GameRules:GetGameTime() / 60
	local attack_speed = 0.029*math.pow(time,2) + 2.66*time - 20
	
	if attack_speed < 0 then attack_speed = 0 end

	return attack_speed
end

function modifier_summon:GetModifierPhysicalArmorBonus(params)
	local time = GameRules:GetGameTime() / 60
	local armor = math.pow(math.sqrt(time - 15), (2.718*0.88))
	
	if time < 15 then armor = 0 end -- caused by sqrt(-15)

	return armor
end

function modifier_summon:OnCreated(event)
end
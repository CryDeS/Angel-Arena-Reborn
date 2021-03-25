modifier_broodmother_spiders = class({})

function modifier_broodmother_spiders:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_broodmother_spiders:IsHidden()
	return true
end

function modifier_broodmother_spiders:IsPurgable()
	return false
end

function modifier_broodmother_spiders:GetModifierExtraHealthBonus(params)
	local time = GameRules:GetGameTime() / 60

	if time < 15 then return 0 end

	return ((time - 15)/5)*40
end

function modifier_broodmother_spiders:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60
	
	if time < 10 then
		return 0
	end

	local multipler = 2 

	if time > 20 then
		multipler = 3
	end

	if time > 30 then
		multipler = 5
	end

	return time*multipler 
end

function modifier_broodmother_spiders:GetModifierPhysicalArmorBonus(params)
	local time = GameRules:GetGameTime() / 60

	if time < 5 then return end 

	return time*0.5
end

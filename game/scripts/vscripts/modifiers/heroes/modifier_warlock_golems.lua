modifier_warlock_golems = class({})

function modifier_warlock_golems:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_warlock_golems:IsHidden()
	return true
end

function modifier_warlock_golems:IsPurgable()
	return false
end

function modifier_warlock_golems:GetModifierBaseAttack_BonusDamage(params)
	local time = GameRules:GetGameTime() / 60


	return 8*time
end

function modifier_warlock_golems:GetModifierPhysicalArmorBonus(params)
	local time = GameRules:GetGameTime() / 60

	return time * 0.7
end

function modifier_warlock_golems:OnCreated(event)
	if not IsServer() then return end
	local parent = self:GetParent()
	local time = GameRules:GetGameTime() / 60
	local health = parent:GetMaxHealth() + time*100
	parent:SetBaseMaxHealth(health)
	parent:SetMaxHealth(health)
	parent:SetHealth(health)
end
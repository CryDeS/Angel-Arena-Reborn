modifier_medical_tractate = class({})


function modifier_medical_tractate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
 
	return funcs
end

function modifier_medical_tractate:GetAttributes()
	local attrs = {
			MODIFIER_ATTRIBUTE_PERMANENT,
		}

	return attrs
end

function modifier_medical_tractate:IsHidden()
	return true
end

function modifier_medical_tractate:IsPurgable()
	return false
end

function modifier_medical_tractate:GetModifierHealthBonus(params)
	if not self:GetCaster() then return 0 end
	self:GetCaster().medical_tractates = self:GetCaster().medical_tractates or 0

	return self.health_bonus*self:GetCaster().medical_tractates
end

function modifier_medical_tractate:OnCreated(event)
	self.health_bonus = 500;
	self.mana_bonus = 300;
	self.armor_bonus = 5;
end

function modifier_medical_tractate:GetModifierManaBonus(event)
	if not self:GetCaster() then return 0 end
	self:GetCaster().medical_tractates = self:GetCaster().medical_tractates or 0
	
	return self.mana_bonus*self:GetCaster().medical_tractates
end

function modifier_medical_tractate:GetModifierPhysicalArmorBonus(event)
	if self:GetCaster():IsHero() then
		return 0
	else 
		return self.armor_bonus
	end
end


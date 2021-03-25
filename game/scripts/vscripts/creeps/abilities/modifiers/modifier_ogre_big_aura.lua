modifier_ogre_big_aura = class({})
--------------------------------------------------------------------------------

function modifier_ogre_big_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_ogre_big_aura:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
	}
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:GetModifierConstantHealthRegen()
	return self.hp_regen
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:GetModifierPhysicalArmorBonus()
	local armor = self.armor

	armor = armor + self.armor_per_5_min * (GameRules:GetGameTime() / 60) / 5
	
	return armor
end

--------------------------------------------------------------------------------

function modifier_ogre_big_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
		self.armor_per_5_min = self:GetAbility():GetSpecialValueFor("armor_per_five_min")
	else 
		self.armor = 0
		self.armor_per_5_min = 0
	end
end

modifier_gnoll_small_two_aura = class({})
--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:GetModifierConstantHealthRegen()
	return self.hp_regen
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_two_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.hp_regen = self:GetAbility():GetSpecialValueFor("hpregen")
		self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	else 
		self.hp_regen = 0
		self.attack_speed = 0
	end
end

modifier_spider_two_aura = class({})
--------------------------------------------------------------------------------

function modifier_spider_two_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_two_aura:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_two_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_spider_two_aura:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
	}
end

--------------------------------------------------------------------------------

function modifier_spider_two_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end

--------------------------------------------------------------------------------

function modifier_spider_two_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.speed = self:GetAbility():GetSpecialValueFor("move_slow")
	else 
		self.speed = 0
	end
end

modifier_ghost_small_blue_aura = class({})
--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, }
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	else 
		self.movespeed = 0
	end
end

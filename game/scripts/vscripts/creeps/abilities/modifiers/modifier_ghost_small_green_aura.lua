modifier_ghost_small_green_aura = class({})
--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.attackspeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	else 
		self.attackspeed = 0
	end
end

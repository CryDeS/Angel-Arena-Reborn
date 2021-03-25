modifier_ghost_small_red_aura = class({})
--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:GetModifierProcAttack_BonusDamage_Magical()
	return self.damage
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.damage = self:GetAbility():GetSpecialValueFor("bonus_mag_damage")
	else 
		self.damage = 0
	end
end

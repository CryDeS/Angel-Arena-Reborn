modifier_gnoll_small_one_aura = class({})
--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:GetModifierProcAttack_BonusDamage_Magical()
	return self.damage
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_aura:OnCreated( kv )
	if self:GetAbility() then 
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
	else 
		self.damage = 0
	end
end

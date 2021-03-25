modifier_ogre_small_buff_enemy = class({})
--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:OnCreated( kv )
	self.debuff_aspeed = self:GetAbility():GetSpecialValueFor("attack_slow")
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:GetModifierAttackSpeedBonus_Constant( kv )
	return self.debuff_aspeed 
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:DeclareFunctions()
	return 
	{ 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	}
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff_enemy:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast.vpcf"
end

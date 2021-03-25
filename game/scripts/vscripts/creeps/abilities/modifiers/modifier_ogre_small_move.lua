modifier_ogre_small_move = class({})

--------------------------------------------------------------------------------

function modifier_ogre_small_move:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_move:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_move:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_move:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_move:OnCreated(kv)
	self.speed = self:GetAbility():GetSpecialValueFor("movement_bonus")
end 

--------------------------------------------------------------------------------

function modifier_ogre_small_move:GetEffectName()
	return "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_buff_b_ti_5.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ogre_small_move:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_ogre_small_move:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

--------------------------------------------------------------------------------
 
function modifier_ogre_small_move:GetModifierMoveSpeedBonus_Constant()
	return self.speed 
end
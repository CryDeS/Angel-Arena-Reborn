modifier_gnoll_small_one_haste = class({})

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:OnCreated(kv)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
end 

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_haste:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge_flame.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_haste:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}
 
	return funcs
end

--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_haste:GetModifierMoveSpeed_AbsoluteMin()
	return self.speed 
end
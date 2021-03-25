modifier_ghost_small_green_wind = class({})

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:OnCreated(kv)
	self.movespeed = kv.movespeed
end 

--------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:GetEffectName()
	return "particles/generic_gameplay/dropped_tango.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ghost_small_green_wind:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------------------------

function modifier_ghost_small_green_wind:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end 

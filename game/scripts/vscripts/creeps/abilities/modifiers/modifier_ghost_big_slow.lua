modifier_ghost_big_slow = class({})

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:OnCreated(kv)
	self.speed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end 

--------------------------------------------------------------------------------

function modifier_ghost_big_slow:GetEffectName()
	return "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target_slowparent_good.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ghost_big_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------------------------------------

function modifier_ghost_big_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end 
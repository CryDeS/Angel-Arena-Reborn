modifier_ghost_big_passive_slow = class({})

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:OnCreated(kv)
	self.movespeed = kv.movespeed
	self.attackspeed = kv.attackspeed
end 

--------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:GetEffectName()
	return "particles/items3_fx/silver_edge_slow.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ghost_big_passive_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------------------------------------

function modifier_ghost_big_passive_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end 

function modifier_ghost_big_passive_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
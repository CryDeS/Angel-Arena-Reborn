modifier_courier = class({})
---------------------------------------------------------------------------
function modifier_courier:IsHidden()
	return true
end

---------------------------------------------------------------------------
function modifier_courier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end

---------------------------------------------------------------------------
function modifier_courier:OnCreated()
	self.add_ms = 150
	self.hp = 130
end

---------------------------------------------------------------------------
function modifier_courier:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

---------------------------------------------------------------------------
function modifier_courier:GetModifierMoveSpeedBonus_Constant()
	return self.add_ms
end

---------------------------------------------------------------------------
function modifier_courier:GetModifierHealthBonus()
	return self.hp
end

---------------------------------------------------------------------------
function modifier_courier:RemoveOnDeath()
	return false
end

---------------------------------------------------------------------------
function modifier_courier:GetVisualZDelta()
	return 150
end

---------------------------------------------------------------------------
function modifier_courier:GetModifierModelChange()
	return "models/props_gameplay/donkey_wings.vmdl"
end
---------------------------------------------------------------------------

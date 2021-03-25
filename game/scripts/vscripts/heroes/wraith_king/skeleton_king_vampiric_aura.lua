skeleton_king_vampiric_aura = class({})
LinkLuaModifier("modifier_wk_vamp_aura", "heroes/wraith_king/modifier_wk_vamp_aura", LUA_MODIFIER_MOTION_NONE)

function skeleton_king_vampiric_aura:GetIntrinsicModifierName( ... )
	return "modifier_wk_vamp_aura"
end

function skeleton_king_vampiric_aura:ProcsMagicStick()
	return false
end
item_material_projector = item_material_projector or class({})
local ability = item_material_projector

LinkLuaModifier("modifier_material_projector", 'items/material_projector/modifiers/modifier_material_projector', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_material_projector"
end

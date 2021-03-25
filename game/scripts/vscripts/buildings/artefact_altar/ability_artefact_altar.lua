ability_artefact_altar = ability_artefact_altar or class({})
local ability = ability_artefact_altar

LinkLuaModifier( "modifier_ability_artefact_altar", "buildings/artefact_altar/modifiers/modifier_ability_artefact_altar", LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_ability_artefact_altar"
end

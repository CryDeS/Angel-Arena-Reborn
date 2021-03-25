ability_shrine_restore = ability_shrine_restore or class({})
LinkLuaModifier( "modifier_ability_shrine_restore", "buildings/shrine/modifier_ability_shrine_restore", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_shrine_restore_effect", "buildings/shrine/modifier_ability_shrine_restore_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ability_shrine_restore:GetIntrinsicModifierName()
	return "modifier_ability_shrine_restore"
end

--------------------------------------------------------------------------------

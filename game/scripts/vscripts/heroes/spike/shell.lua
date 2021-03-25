angel_arena_shell = class({})
LinkLuaModifier( "modifier_spike_shell", 'heroes/spike/modifiers/modifier_spike_shell', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function angel_arena_shell:GetIntrinsicModifierName()
	return "modifier_spike_shell"
end

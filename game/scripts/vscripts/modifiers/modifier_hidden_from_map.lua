modifier_hidden_from_map = modifier_hidden_from_map or class({})

function modifier_hidden_from_map:IsHidden()
	return false
end

function modifier_hidden_from_map:IsPurgable()
	return false
end

function modifier_hidden_from_map:CheckState() return {
	[MODIFIER_STATE_STUNNED] 				= true,
	[MODIFIER_STATE_INVULNERABLE] 			= true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	[MODIFIER_STATE_OUT_OF_GAME] 			= true,
	[MODIFIER_STATE_MAGIC_IMMUNE] 			= true,
	[MODIFIER_STATE_ATTACK_IMMUNE] 			= true,
	[MODIFIER_STATE_UNSELECTABLE] 			= true,
	[MODIFIER_STATE_LOW_ATTACK_PRIORITY] 	= true,
	[MODIFIER_STATE_NO_HEALTH_BAR] 			= true,
	[MODIFIER_STATE_TRUESIGHT_IMMUNE] 		= true,
} end

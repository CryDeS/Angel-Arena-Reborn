modifier_full_disable_stun = class({})

function modifier_full_disable_stun:IsHidden()
	return true
end

function modifier_full_disable_stun:IsPurgable()
	return false
end

function modifier_full_disable_stun:OnCreated()

end

function modifier_full_disable_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_BLIND] = true,
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
 
	return state
end

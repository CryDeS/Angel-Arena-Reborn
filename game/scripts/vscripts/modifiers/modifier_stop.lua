modifier_stop = class({})

function modifier_stop:IsHidden()
	return true
end

function modifier_stop:IsPurgable()
	return false
end

function modifier_stop:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end

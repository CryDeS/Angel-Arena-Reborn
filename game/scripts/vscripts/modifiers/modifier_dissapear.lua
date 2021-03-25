modifier_dissapear = class({})

function modifier_dissapear:IsHidden()
	return true
end

function modifier_dissapear:IsPurgable()
	return false
end

function modifier_dissapear:OnCreated()

end

function modifier_dissapear:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] 			= true,
		[MODIFIER_STATE_INVISIBLE] 			= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_OUT_OF_GAME]		= true,
	}
 
	return state
end

huntress_owl_modifier_current_value = huntress_owl_modifier_current_value or class({})

local mod = huntress_owl_modifier_current_value

function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:IsHidden() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsDebuff() 		return false end

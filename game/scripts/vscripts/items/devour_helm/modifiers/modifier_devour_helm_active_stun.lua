modifier_devour_helm_active_stun = modifier_devour_helm_active_stun or class({})
local mod = modifier_devour_helm_active_stun

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function mod:CheckState() return 
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
}
end

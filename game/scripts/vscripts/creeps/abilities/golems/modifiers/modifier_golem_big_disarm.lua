modifier_golem_big_disarm = class({})

--------------------------------------------------------------------------------

function modifier_golem_big_disarm:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_big_disarm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_big_disarm:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_golem_big_disarm:CheckState() return 
{ 
	[MODIFIER_STATE_DISARMED] = true, 
} 
end
--------------------------------------------------------------------------------

function modifier_golem_big_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_golem_big_disarm:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


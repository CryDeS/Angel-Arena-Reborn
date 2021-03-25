modifier_golem_small_silence = class({})

--------------------------------------------------------------------------------

function modifier_golem_small_silence:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_small_silence:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_small_silence:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_golem_small_silence:CheckState() return 
{ 
	[MODIFIER_STATE_SILENCED] = true, 
} 
end
--------------------------------------------------------------------------------

function modifier_golem_small_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_golem_small_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


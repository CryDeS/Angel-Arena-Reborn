modifier_spider_one_grid_stun = class({})
--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_spider_one_grid_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid_stun:CheckState()
	return 
	{ 
		[MODIFIER_STATE_STUNNED] = true, 
	}
end
modifier_spider_one_passive = class({})
--------------------------------------------------------------------------------

function modifier_spider_one_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_one_passive:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_passive:OnCreated( kv )
end
 
--------------------------------------------------------------------------------

function modifier_spider_one_passive:CheckState()
	return 
	{ 
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
	}
end
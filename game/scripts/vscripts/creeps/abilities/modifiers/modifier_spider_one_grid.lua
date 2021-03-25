modifier_spider_one_grid = class({})

--------------------------------------------------------------------------------

function modifier_spider_one_grid:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_grid:OnCreated(kv)
end 

--------------------------------------------------------------------------------

function modifier_spider_one_grid:GetEffectName()
	return "particles/neutral_fx/dark_troll_ensnare.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_spider_one_grid:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_spider_one_grid:CheckState()
	return 
	{ 
		[MODIFIER_STATE_ROOTED] = true, 
	}
end
spider_one_passive = class({})
LinkLuaModifier( "modifier_spider_one_passive", 'creeps/abilities/modifiers/modifier_spider_one_passive', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function spider_one_passive:GetIntrinsicModifierName()
	return "modifier_spider_one_passive"
end
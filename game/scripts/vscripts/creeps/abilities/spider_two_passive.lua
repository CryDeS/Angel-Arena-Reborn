spider_two_passive = class({})
LinkLuaModifier( "modifier_spider_two_passive", 'creeps/abilities/modifiers/modifier_spider_two_passive', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function spider_two_passive:GetIntrinsicModifierName()
	return "modifier_spider_two_passive"
end
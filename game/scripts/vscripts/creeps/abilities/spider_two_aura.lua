spider_two_aura = class({})
LinkLuaModifier( "modifier_spider_two_aura", 'creeps/abilities/modifiers/modifier_spider_two_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_two_aura_emitter", 'creeps/abilities/modifiers/modifier_spider_two_aura_emitter', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function spider_two_aura:GetIntrinsicModifierName()
	return "modifier_spider_two_aura_emitter"
end
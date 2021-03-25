spider_one_poison = spider_one_poison or class({})
LinkLuaModifier( "modifier_spider_one_poison", 'creeps/abilities/modifiers/modifier_spider_one_poison', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spider_one_poison:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_spider_one_poison", {duration = self:GetSpecialValueFor("duration")})
end

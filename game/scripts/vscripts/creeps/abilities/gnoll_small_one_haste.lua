gnoll_small_one_haste = class({})
LinkLuaModifier( "modifier_gnoll_small_one_haste", 'creeps/abilities/modifiers/modifier_gnoll_small_one_haste', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gnoll_small_one_haste:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	
	target:AddNewModifier(caster, self, "modifier_gnoll_small_one_haste", 
	{ 
		speed = self:GetSpecialValueFor("speed"),
		duration = self:GetSpecialValueFor("duration")
	})
end
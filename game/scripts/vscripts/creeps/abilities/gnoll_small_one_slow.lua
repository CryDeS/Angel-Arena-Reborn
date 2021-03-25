gnoll_small_one_slow = class({})
LinkLuaModifier( "modifier_gnoll_small_one_slow", 'creeps/abilities/modifiers/modifier_gnoll_small_one_slow', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gnoll_small_one_slow:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if target:TriggerSpellAbsorb( self ) then return end  
		
	target:AddNewModifier(caster, self, "modifier_gnoll_small_one_slow", 
	{ 
		duration = self:GetSpecialValueFor("duration"),
	})
end
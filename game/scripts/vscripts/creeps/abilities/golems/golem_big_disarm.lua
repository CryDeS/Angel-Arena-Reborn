golem_big_disarm = golem_big_disarm or class({})
LinkLuaModifier( "modifier_golem_big_disarm", 'creeps/abilities/golems/modifiers/modifier_golem_big_disarm', LUA_MODIFIER_MOTION_NONE )


function golem_big_disarm:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster() , self, "modifier_golem_big_disarm", { duration = self:GetSpecialValueFor("duration") } )
end

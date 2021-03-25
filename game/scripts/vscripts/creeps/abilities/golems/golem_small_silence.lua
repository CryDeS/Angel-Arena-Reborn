golem_small_silence = golem_small_silence or class({})
LinkLuaModifier( "modifier_golem_small_silence", 'creeps/abilities/golems/modifiers/modifier_golem_small_silence', LUA_MODIFIER_MOTION_NONE )


function golem_small_silence:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster() , self, "modifier_golem_small_silence", { duration = self:GetSpecialValueFor("duration") } )
end

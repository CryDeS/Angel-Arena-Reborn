small_satyr_little_slow = class({})
LinkLuaModifier("modifier_small_satyr_little_slow", "creeps/abilities/npc_aa_creep_small_satyr_little/modifier_small_satyr_little_slow", LUA_MODIFIER_MOTION_NONE)


function small_satyr_little_slow:OnSpellStart() 
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb( self ) then
		return
	else
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_small_satyr_little_slow", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end
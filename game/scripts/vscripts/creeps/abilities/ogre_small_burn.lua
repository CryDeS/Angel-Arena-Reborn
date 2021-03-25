ogre_small_burn = class({})
LinkLuaModifier( "modifier_ogre_small_burn", 'creeps/abilities/modifiers/modifier_ogre_small_burn', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ogre_small_burn:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb( self ) then return end  
		
	target:AddNewModifier(caster, self, "modifier_ogre_small_burn", { duration = self:GetSpecialValueFor("duration") } )
end
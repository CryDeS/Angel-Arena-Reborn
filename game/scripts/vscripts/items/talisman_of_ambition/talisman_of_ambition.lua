item_talisman_of_ambition = item_talisman_of_ambition or class({}) 
LinkLuaModifier( "modifier_talisman_of_ambition", 'items/talisman_of_ambition/modifiers/modifier_talisman_of_ambition', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_talisman_of_ambition_active", 'items/talisman_of_ambition/modifiers/modifier_talisman_of_ambition_active', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_talisman_of_ambition:GetIntrinsicModifierName()
	return "modifier_talisman_of_ambition"
end

function item_talisman_of_ambition:OnSpellStart()
	local caster 			= self:GetCaster() 
	local original_target	= self:GetCursorTarget()
	
	if PlayerResource:IsDisableHelpSetForPlayerID(caster:GetPlayerOwnerID(), original_target:GetPlayerOwnerID() ) then
		return 
	end

	original_target:AddNewModifier(caster, self, "modifier_talisman_of_ambition_active", 
		{ 
			duration =  self:GetSpecialValueFor("duration"),
			evasion  = 	self:GetSpecialValueFor("evasion") 
		}
	)
end

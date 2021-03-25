ghost_small_blue_magic_curse = class({})
LinkLuaModifier( "modifier_ghost_small_blue_magic_curse", 'creeps/abilities/modifiers/modifier_ghost_small_blue_magic_curse', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ghost_small_blue_magic_curse:OnSpellStart( keys )
	self:GetCursorTarget():EmitSound("DOTA_Item.VeilofDiscord.Activate")
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ghost_small_blue_magic_curse", {resist = self:GetSpecialValueFor("magical_resist_pct"), duration = self:GetSpecialValueFor("duration") } ) 
end
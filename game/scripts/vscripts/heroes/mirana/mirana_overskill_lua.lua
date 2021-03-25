mirana_overskill_lua = class({})
LinkLuaModifier("modifier_mirana_overskill_lua", "heroes/mirana/modifier_mirana_overskill_lua", LUA_MODIFIER_MOTION_NONE)


function mirana_overskill_lua:OnSpellStart()
	local overskill_duration = self:GetSpecialValueFor( "overskill_duration" )
	local mod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_mirana_overskill_lua", { duration = overskill_duration } ) 
	if IsServer() then
		local agility = self:GetCaster():GetAgility()
		local agi_multiplier = self:GetSpecialValueFor( "agi_multiplier" )
		if not mod.refreshed then
			mod:SetStackCount(agility * agi_multiplier) 
			mod:ForceRefresh()
		end
		
	end
end 
	
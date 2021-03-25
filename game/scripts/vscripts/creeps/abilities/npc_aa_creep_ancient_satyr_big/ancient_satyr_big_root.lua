ancient_satyr_big_root = ancient_satyr_big_root or class({})
LinkLuaModifier( "modifier_ancient_satyr_big_root", "creeps/abilities/npc_aa_creep_ancient_satyr_big/modifier_ancient_satyr_big_root", LUA_MODIFIER_MOTION_NONE )

function ancient_satyr_big_root:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function ancient_satyr_big_root:OnSpellStart()
    if not IsServer() then return end

	local enemies = FindUnitsInRadius(	self:GetCaster():GetTeamNumber(), 
										self:GetCursorPosition(), 
										nil, 
										self:GetSpecialValueFor("radius"), 
										self:GetAbilityTargetTeam(), 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										0, 
										0, 
										false) 
	

	if not enemies or #enemies == 0 then
		return
	end 

	for _,enemy in pairs(enemies) do
		if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_ancient_satyr_big_root", { duration = self:GetSpecialValueFor("duration") } )
		end
	end
end
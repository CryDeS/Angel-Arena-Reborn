ancient_dragon_small_antiheal = class({})
LinkLuaModifier("modifier_ancient_dragon_small_antiheal","creeps/abilities/npc_aa_creep_ancient_dragon_small/modifier_ancient_dragon_small_antiheal", LUA_MODIFIER_MOTION_NONE)

function ancient_dragon_small_antiheal:OnSpellStart()
	if not IsServer() then
		return
	end
	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb( self ) then
		return
	else 
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ancient_dragon_small_antiheal", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end
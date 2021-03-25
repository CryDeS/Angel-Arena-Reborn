ancient_dragon_small_cd_reduction = ancient_dragon_small_cd_reduction or class({})
LinkLuaModifier("modifier_ancient_dragon_small_cd_reduction","creeps/abilities/npc_aa_creep_ancient_dragon_small/modifier_ancient_dragon_small_cd_reduction",LUA_MODIFIER_MOTION_NONE)

function ancient_dragon_small_cd_reduction:OnSpellStart()
	if not IsServer() then
		return
	end

	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ancient_dragon_small_cd_reduction", { duration = self:GetSpecialValueFor( "duration" ) } )
end
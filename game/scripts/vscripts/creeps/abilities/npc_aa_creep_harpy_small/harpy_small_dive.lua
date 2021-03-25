harpy_small_dive = class({})
LinkLuaModifier( "modifier_harpy_small_dive_active", "creeps/abilities/npc_aa_creep_harpy_small/modifiers/modifier_harpy_small_dive_active", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_harpy_small_dive_active_stun", "creeps/abilities/npc_aa_creep_harpy_small/modifiers/modifier_harpy_small_dive_active_stun", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function harpy_small_dive:OnSpellStart()
	local height			= self:GetSpecialValueFor( "height" )
	local speed				= self:GetSpecialValueFor( "speed" )
	local damage			= self:GetSpecialValueFor( "damage" )
	local radius			= self:GetSpecialValueFor( "radius" )
	local self_dmg 			= self:GetSpecialValueFor( "damage_self" )
	local caster 			= self:GetCaster()
	local duration   		= self:GetSpecialValueFor( "duration" )

	caster:AddNewModifier(caster, self, "modifier_harpy_small_dive_active", { damage_self = self_dmg, speed = speed, height = height,  damage = damage, radius = radius, duration = duration })
end

--------------------------------------------------------------------------------
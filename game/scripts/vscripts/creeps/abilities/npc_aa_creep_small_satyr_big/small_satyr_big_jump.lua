small_satyr_big_jump = class({})

LinkLuaModifier("modifier_small_satyr_big_jump", "creeps/abilities/npc_aa_creep_small_satyr_big/modifier_small_satyr_big_jump", LUA_MODIFIER_MOTION_BOTH)

---------------------------------------------------------------------------

function small_satyr_big_jump:OnSpellStart()
	local caster = self:GetCaster() 
	local duration = self:GetSpecialValueFor("duration")
	local pt = self:GetCursorPosition() 

	local spt = caster:GetAbsOrigin() 

	caster:AddNewModifier(caster, self, "modifier_small_satyr_big_jump", { 	duration = duration, 
																			sx = spt.x, sy = spt.y, sz = spt.z, 
																			x = pt.x, y = pt.y, z = pt.z }) 
end

---------------------------------------------------------------------------
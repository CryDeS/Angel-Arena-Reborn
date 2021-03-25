harpy_small_fly = class({})

LinkLuaModifier( "modifier_harpy_small_fly", "creeps/abilities/npc_aa_creep_harpy_small/modifiers/modifier_harpy_small_fly", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function harpy_small_fly:OnToggle()
	local caster = self:GetCaster() 

	if self:GetToggleState() then 
		caster:AddNewModifier(caster, self, "modifier_harpy_small_fly", { duration = -1 })
	else
		caster:RemoveModifierByName("modifier_harpy_small_fly")
	end 
end

--------------------------------------------------------------------------------
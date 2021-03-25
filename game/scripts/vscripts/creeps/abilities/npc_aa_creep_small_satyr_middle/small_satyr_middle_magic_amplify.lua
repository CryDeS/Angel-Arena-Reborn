small_satyr_middle_magic_amplify = class({})
LinkLuaModifier("modifier_small_satyr_middle_magic_amplify", "creeps/abilities/npc_aa_creep_small_satyr_middle/modifier_small_satyr_middle_magic_amplify", LUA_MODIFIER_MOTION_NONE)

function small_satyr_middle_magic_amplify:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_small_satyr_middle_magic_amplify", { duration = self:GetSpecialValueFor("duration") })
end

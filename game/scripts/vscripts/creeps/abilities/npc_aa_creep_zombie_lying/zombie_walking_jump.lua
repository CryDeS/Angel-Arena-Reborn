zombie_walking_jump = class({})
LinkLuaModifier("modifier_zombie_walking_jump_active", "creeps/abilities/npc_aa_creep_zombie_lying/modifier_zombie_walking_jump_active", LUA_MODIFIER_MOTION_HORIZONTAL)

-----------------------------------------------------------------------------
function zombie_walking_jump:OnSpellStart()
    local caster = self:GetCaster()
    local speed = self:GetSpecialValueFor("speed")

    caster:AddNewModifier(caster, self, "modifier_zombie_walking_jump_active", { speed = speed })
end

-----------------------------------------------------------------------------
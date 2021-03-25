demon_warrior_invisible = class({})
LinkLuaModifier("modifier_demon_warrior_invisible", "creeps/abilities/npc_aa_creep_demon_warrior/modifier_demon_warrior_invisible", LUA_MODIFIER_MOTION_NONE)

function demon_warrior_invisible:OnSpellStart()

    self.duration = self:GetSpecialValueFor("duration")
    local part = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(part, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_demon_warrior_invisible", { duration = self.duration })
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invisible", { duration = self.duration })
end

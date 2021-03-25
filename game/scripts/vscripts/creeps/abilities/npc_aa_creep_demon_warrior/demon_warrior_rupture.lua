demon_warrior_rupture = class({})
LinkLuaModifier("modifier_demon_warrior_rupture", "creeps/abilities/npc_aa_creep_demon_warrior/modifier_demon_warrior_rupture", LUA_MODIFIER_MOTION_NONE)

function demon_warrior_rupture:OnSpellStart()
    local target = self:GetCursorTarget()
    if target:TriggerSpellAbsorb(self) then
        return
    end

    self.duration = self:GetSpecialValueFor("duration")
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_demon_warrior_rupture", { duration = self.duration })
end

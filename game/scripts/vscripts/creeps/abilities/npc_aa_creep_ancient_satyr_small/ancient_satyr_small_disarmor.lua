ancient_satyr_small_disarmor = class({})
LinkLuaModifier( "modifier_ancient_satyr_small_disarmor", "creeps/abilities/npc_aa_creep_ancient_satyr_small/modifier_ancient_satyr_small_disarmor", LUA_MODIFIER_MOTION_NONE )

function ancient_satyr_small_disarmor:OnSpellStart()
    if not IsServer() then return end
    local hTarget = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    if hTarget:TriggerSpellAbsorb(self) then
        return
    else
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_ancient_satyr_small_disarmor", { duration = duration })
    end
end
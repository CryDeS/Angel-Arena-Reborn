demon_archer_buff_attack_range = class({})
LinkLuaModifier("modifier_demon_archer_buff_attack_range", "creeps/abilities/npc_aa_creep_demon_archer/modifier_demon_archer_buff_attack_range", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------------
function demon_archer_buff_attack_range:GetCustomCastErrorTarget(hTarget)
    if not hTarget:IsRangedAttacker() then
        return UF_FAIL_MELEE
    end
    return ""
end

----------------------------------------------------------------------------
function demon_archer_buff_attack_range:CastFilterResultTarget(hTarget)
    if not hTarget:IsRangedAttacker() then
        return UF_FAIL_MELEE
    end
    return UF_SUCCESS
end

----------------------------------------------------------------------------
function demon_archer_buff_attack_range:OnSpellStart()
    print(self:GetCursorTarget():IsRangedAttacker())
    self.duration = self:GetSpecialValueFor("duration")

    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_demon_archer_buff_attack_range", { duration = self.duration })
end

----------------------------------------------------------------------------
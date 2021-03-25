modifier_demon_archer_buff_attack_range = class({})
--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:OnCreated(kv)
    self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
    self.particleAttackRangeArcher = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.particleAttackRangeArcher, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:OnRefresh(kv)
    self.bonus_attack_spd = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end


--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:GetModifierAttackRangeBonus(params)
        return self.bonus_attack_range
end

--------------------------------------------------------------------------------
function modifier_demon_archer_buff_attack_range:OnDestroy(params)
    ParticleManager:DestroyParticle(self.particleAttackRangeArcher, false)
end

-------------------------------------------------------------------------------


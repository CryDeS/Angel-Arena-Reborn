modifier_npc_aa_creep_centaur_small_up_ms_lua = class({})
--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:OnCreated(kv)
    self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:OnRefresh(kv)
    self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:GetEffectName()
    return "particles/units/heroes/hero_centaur/centaur_stampede_overhead_model.vpcf"
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_up_ms_lua:GetModifierMoveSpeedBonus_Percentage(params)
    return self.bonus_movespeed_pct
end

--------------------------------------------------------------------------------
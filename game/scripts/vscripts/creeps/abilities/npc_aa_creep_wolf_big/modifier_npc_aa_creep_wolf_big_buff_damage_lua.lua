modifier_npc_aa_creep_wolf_big_buff_damage_lua = class({})
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:GetEffectName()
    return "particles/buff_damage2/buff_damage2.vpcf"
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:OnCreated( kv )
    self.bonus_all_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_all_damage_pct" )
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:OnRefresh( kv )
    self.bonus_all_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_all_damage_pct" )
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_big_buff_damage_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_buff_damage_lua:GetModifierTotalDamageOutgoing_Percentage( params )
    return self.bonus_all_damage_pct
end

--------------------------------------------------------------------------------
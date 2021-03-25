modifier_npc_aa_creep_salamander_big_damage_abs_lua = class({})

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:OnCreated( kv )
    self.damage_absorb_pct = self:GetAbility():GetSpecialValueFor( "damage_absorb_pct" )
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:OnRefresh( kv )
    self.damage_absorb_pct = self:GetAbility():GetSpecialValueFor( "damage_absorb_pct" )
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_damage_abs_lua:GetModifierIncomingDamage_Percentage( params )
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return -self.damage_absorb_pct
end

--------------------------------------------------------------------------------
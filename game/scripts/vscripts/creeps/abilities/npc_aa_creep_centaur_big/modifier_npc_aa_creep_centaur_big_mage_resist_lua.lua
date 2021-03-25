modifier_npc_aa_creep_centaur_big_mage_resist_lua = class({})
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:IsHidden()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:OnCreated( kv )
    self.mage_resist_pct = self:GetAbility():GetSpecialValueFor( "mage_resist_pct" )
    self.particle = ParticleManager:CreateParticle( "particles/mage_resist/mage_resist.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW  , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)


end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:OnRefresh( kv )
    self.mage_resist_pct = self:GetAbility():GetSpecialValueFor( "mage_resist_pct" )
end


--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_big_mage_resist_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:GetModifierMagicalResistanceBonus( params )
    return self.mage_resist_pct
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_mage_resist_lua:OnDestroy ( params )
    ParticleManager:DestroyParticle(self.particle,false)
end

-------------------------------------------------------------------------------
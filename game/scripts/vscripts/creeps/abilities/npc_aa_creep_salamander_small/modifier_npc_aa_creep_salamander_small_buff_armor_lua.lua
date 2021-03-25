modifier_npc_aa_creep_salamander_small_buff_armor_lua = class({})
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:IsSilenced()
    return true
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:OnCreated( kv )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
    self.particlearm = ParticleManager:CreateParticle( "particles/armor/armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.particlearm, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:OnRefresh( kv )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_salamander_small_buff_armor_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:GetModifierPhysicalArmorBonus ( params )
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self.bonus_armor
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_armor_lua:OnDestroy ( params )
    ParticleManager:DestroyParticle(self.particlearm,false)
end

-------------------------------------------------------------------------------
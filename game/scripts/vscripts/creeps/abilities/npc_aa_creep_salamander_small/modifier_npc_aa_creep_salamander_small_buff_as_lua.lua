modifier_npc_aa_creep_salamander_small_buff_as_lua = class({})
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:IsHidden()
    return false
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:OnCreated( kv )
    self.bonus_attack_spd = self:GetAbility():GetSpecialValueFor( "bonus_attack_spd" )
    self.particleSpd = ParticleManager:CreateParticle( "particles/speed_bonus/speed_bonus.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.particleSpd, 0, self:GetParent(), PATTACH_POINT_FOLLOW  , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:OnRefresh( kv )
    self.bonus_attack_spd = self:GetAbility():GetSpecialValueFor( "bonus_attack_spd" )
end


--------------------------------------------------------------------------------
function modifier_npc_aa_creep_salamander_small_buff_as_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:GetModifierAttackSpeedBonus_Constant( params )
    return self.bonus_attack_spd
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_small_buff_as_lua:OnDestroy ( params )
    ParticleManager:DestroyParticle(self.particleSpd,false)
end

-------------------------------------------------------------------------------


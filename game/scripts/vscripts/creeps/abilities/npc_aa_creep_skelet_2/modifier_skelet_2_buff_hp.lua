modifier_skelet_2_buff_hp = class({})
--------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:IsHidden()
    return false
end
--------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:OnCreated( kv )
    self.bonus_health_pct = self:GetAbility():GetSpecialValueFor( "bonus_health_pct" )
    self.particleSpd = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.particleSpd, 0, self:GetParent(), PATTACH_POINT_FOLLOW  , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:OnRefresh( kv )
    self.bonus_attack_spd = self:GetAbility():GetSpecialValueFor( "bonus_health_pct" )
end


--------------------------------------------------------------------------------
function modifier_skelet_2_buff_hp:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:GetModifierExtraHealthPercentage( params )
    return self.bonus_health_pct
end

--------------------------------------------------------------------------------

function modifier_skelet_2_buff_hp:OnDestroy ( params )
    ParticleManager:DestroyParticle(self.particleSpd,false)
end

-------------------------------------------------------------------------------


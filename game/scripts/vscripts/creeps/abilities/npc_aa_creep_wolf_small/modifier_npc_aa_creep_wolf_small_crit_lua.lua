modifier_npc_aa_creep_wolf_small_crit_lua = class({})
--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_crit_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_crit_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_small_crit_lua:OnCreated(kv)
    self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
    self.crit_damage = self:GetAbility():GetSpecialValueFor("crit_damage")
    self.particleCrit = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_bramble_steam_evil.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.particleCrit, 0, self:GetParent(), PATTACH_POINT_FOLLOW  , "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
end

-------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_crit_lua:OnRefresh(kv)
    self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
    self.crit_damage = self:GetAbility():GetSpecialValueFor("crit_damage")
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_crit_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_wolf_small_crit_lua:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        if self:GetCaster():PassivesDisabled() then
            return 0
        end
        if params.target ~= nil and RollPercentage(self.crit_chance) then
            return self.crit_damage
        end
    end
end

-----------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_small_crit_lua:OnDestroy ( params )
    ParticleManager:DestroyParticle(self.particleCrit,false)
end

-------------------------------------------------------------------------------

npc_aa_creep_centaur_small_net_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_centaur_small_net_lua", "creeps/abilities/npc_aa_creep_centaur_small/modifier_npc_aa_creep_centaur_small_net_lua", LUA_MODIFIER_MOTION_NONE)
-----------------------------------------------------------------------------
function npc_aa_creep_centaur_small_net_lua:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    self.speed = self:GetSpecialValueFor("speed")
    local info = {
        EffectName = "particles/net_on_fly/net_on_fly.vpcf",
        Ability = self,
        iMoveSpeed = self.speed,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

-----------------------------------------------------------------------------
function npc_aa_creep_centaur_small_net_lua:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsInvulnerable()) and (not hTarget:TriggerSpellAbsorb(self)) then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_npc_aa_creep_centaur_small_net_lua", { duration = self.duration })
    end
end

-----------------------------------------------------------------------------
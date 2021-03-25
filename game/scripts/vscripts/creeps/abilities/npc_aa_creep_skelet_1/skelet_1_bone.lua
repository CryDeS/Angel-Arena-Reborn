skelet_1_bone = class({})
LinkLuaModifier("modifier_skelet_1_bone", "creeps/abilities/npc_aa_creep_skelet_1/modifier_skelet_1_bone", LUA_MODIFIER_MOTION_NONE)

function skelet_1_bone:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    self.damage = self:GetSpecialValueFor("damage")
    self.speed = self:GetSpecialValueFor("speed")

    local info = {
        EffectName = "particles/bone_proj/bone_proj.vpcf",
        Ability = self,
        iMoveSpeed = self.speed,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function skelet_1_bone:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsInvulnerable()) and (not hTarget:TriggerSpellAbsorb(self)) then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_skelet_1_bone", { duration = self.duration })
        local info = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage(info)
    end
end
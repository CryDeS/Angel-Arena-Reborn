modifier_item_shard_joe_black_active = class({})

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:GetTexture()
    return "../items/shard_joe_black_big"
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:OnCreated(kv)
    self.damage_abs_pct = self:GetAbility():GetSpecialValueFor("damage_abs_pct")
    self.parent = self:GetParent()
    self.particleShardJB = ParticleManager:CreateParticle("particles/item_shard_joe_black/item_shard_joe_black.vpcf", PATTACH_POINT_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(self.particleShardJB, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:GetModifierIncomingDamage_Percentage()
    return -self.damage_abs_pct
end
-----------------------------------------------------------------------------
function modifier_item_shard_joe_black_active:OnDestroy()
    ParticleManager:DestroyParticle(self.particleShardJB, false)
end
-----------------------------------------------------------------------------
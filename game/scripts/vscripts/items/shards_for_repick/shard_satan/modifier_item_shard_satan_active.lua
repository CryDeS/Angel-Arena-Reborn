modifier_item_shard_satan_active = class({})
-------------------------------------------------------------------------------------------------------------
function modifier_item_shard_satan_active:IsPurgable()
    return true
end

-----------------------------------------------------------------------------
function modifier_item_shard_satan_active:IsDebuff()
    return true
end

-----------------------------------------------------------------------------
function modifier_item_shard_satan_active:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:GetTexture()
    return "../items/shard_satan_big"
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------
function damagePerTimeSatanShard(parent, damage, time, caster, ability)
    if not IsServer() then return end
    Timers:CreateTimer("modifier_item_shard_satan_active" .. tostring(parent:entindex()), {
        useGameTime = true,
        endTime = time,
        callback = function()
            if not parent:IsAlive() then return nil end
            local damage = {
                victim = parent,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
            }
            ApplyDamage(damage)
            return time
        end
    })
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:GetEffectName()
    return "particles/item_shard_satan/item_shard_satan_active.vpcf"
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:OnCreated()
    self.move_speed_slow_const = self:GetAbility():GetSpecialValueFor("move_speed_slow_const")
    self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
    self.interval_tick = self:GetAbility():GetSpecialValueFor("interval_tick")
    local ability = self:GetAbility()
    local parent = self:GetParent()
    if not IsServer() then return end
    damagePerTimeSatanShard(parent, self.damage_per_tick, self.interval_tick, ability:GetCaster(), ability)
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:GetModifierMoveSpeedBonus_Constant()
    return -self.move_speed_slow_const
end

--------------------------------------------------------------------------------
function modifier_item_shard_satan_active:OnDestroy()
    if not IsServer() then return end
    Timers:RemoveTimer("modifier_item_shard_satan_active" .. tostring(self:GetParent():entindex()))
end

--------------------------------------------------------------------------------
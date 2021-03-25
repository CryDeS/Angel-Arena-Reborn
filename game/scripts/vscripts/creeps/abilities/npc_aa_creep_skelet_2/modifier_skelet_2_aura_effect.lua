modifier_skelet_2_aura_effect = modifier_skelet_2_aura_effect or class({})

--------------------------------------------------------------------------------
function modifier_skelet_2_aura_effect:IsHidden()
    return false
end

function modifier_skelet_2_aura_effect:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_skelet_2_aura_effect:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function damagePerTime(parent, damage, time)
    if not IsServer() then return end
    Timers:CreateTimer("npc_aa_skelet_2_aura" .. tostring(parent:entindex()), {
        useGameTime = true,
        endTime = 1,
        callback = function()
            if not parent or parent:IsNull() then return end

            if not parent:IsAlive() then return nil end
            
            local newHp = parent:GetHealth() - damage

            if newHp > 1 then
                parent:SetHealth(parent:GetHealth() - damage)
            end

            return time
        end
    })
end

--------------------------------------------------------------------------------
function modifier_skelet_2_aura_effect:OnCreated(kv)
    if self:GetAbility() then
        self.damage_per_second = self:GetAbility():GetSpecialValueFor("damage_per_second")
        self.time_rate_sec = self:GetAbility():GetSpecialValueFor("time_rate_sec")
        local parent = self:GetParent()

        damagePerTime(parent, self.damage_per_second, self.time_rate_sec)
    end
end

-------------------------------------------------------------------------------
function modifier_skelet_2_aura_effect:OnDestroy(params)
    if not IsServer() then return end
    Timers:RemoveTimer("npc_aa_skelet_2_aura" .. tostring(self:GetParent():entindex()))
end

-------------------------------------------------------------------------------
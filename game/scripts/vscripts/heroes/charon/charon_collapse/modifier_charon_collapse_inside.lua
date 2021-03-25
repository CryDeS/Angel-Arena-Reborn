modifier_charon_collapse_inside = modifier_charon_collapse_inside or class({})
local mod = modifier_charon_collapse_inside

--------------------------------------------------------------------------------
function mod:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function mod:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function mod:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function mod:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function mod:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function mod:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function mod:OnCreated(kv)
    if not IsServer() then return end
    if not self or self:IsNull() then return end

    self.duration = kv.duration_full
    self.radius = kv.radius
    self.fSpeed = self.radius / self.duration

    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return end

    self.vPoint = ability:GetCaster():GetOrigin()
    self.manaburn_min = ability:GetSpecialValueFor("manaburn_min")
    self.manaburn_max = ability:GetSpecialValueFor("manaburn_max")
    self.tick_time_mana_burn = ability:GetSpecialValueFor("tick_time_mana_burn")

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end

    local pct_range_position = 0
    local mana_burn = 0
    local target = self:GetParent()
    
    if not target or target:IsNull() then return end
    
    self.timer = Timers:CreateTimer(0.01, function()
            if not ability or ability:IsNull() then return end
            if not target or target:IsNull() then return end

            pct_range_position = 100 / self.radius * ((self.vPoint - target:GetAbsOrigin()):Length2D())
            mana_burn = self.manaburn_max - (self.manaburn_max / 100 * pct_range_position)
            mana_burn = math.min(self.manaburn_max, math.max(mana_burn, self.manaburn_min))

            if target:IsRealHero() and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
                if not target:IsMagicImmune() then
                    target:ReduceMana(mana_burn)
                end
            end

            if target:GetMana() > 1 then
                ability.all_mana_drain = ability.all_mana_drain + mana_burn
            end

            return self.tick_time_mana_burn
        end
    )
end

--------------------------------------------------------------------------------
function mod:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end

    if not self or self:IsNull() then return end

    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end

    local ability = self:GetAbility()
    if not ability or ability:IsNull() then return end

    local vParent_point = parent:GetAbsOrigin()

    if parent:IsAlive() then
        local step = (self.vPoint - vParent_point):Normalized() * (self.fSpeed * dt)
        local origin = parent:GetAbsOrigin()
        local new_pos = origin + step
        if (self.vPoint - vParent_point):Length2D() > 100 and parent:IsAlive() then
            parent:SetAbsOrigin(new_pos)
            FindClearSpaceForUnit(parent, new_pos, false)
        end
    else
        parent:InterruptMotionControllers(true)
    end
end

--------------------------------------------------------------------------------
function mod:OnHorizontalMotionInterrupted()
    if IsServer() and self and not self:IsNull() then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
function mod:OnDestroy()
    if not IsServer() then return end

    local parent = self:GetParent()

    if not parent or parent:IsNull() then return end

    parent:InterruptMotionControllers(true) 

    if self.timer ~= nil then
        Timers:RemoveTimer(self.timer)
        self.timer = nil
    end
end

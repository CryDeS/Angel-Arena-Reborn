modifier_dark_rift_charges = class({})

function modifier_dark_rift_charges:IsHidden()          return self.hidden end
function modifier_dark_rift_charges:IsPurgable()        return false end
function modifier_dark_rift_charges:RemoveOnDeath()     return false end
function modifier_dark_rift_charges:DestroyOnExpire()   return false end

function modifier_dark_rift_charges:OnCreated()
    self.hidden = true

    self.parent = self:GetParent()
    
    self.ability = self:GetAbility()
    self.ability.dark_rift_mod = self
    self.charges_max = self.ability:GetSpecialValueFor("max_charges")
    self.charges_cooldown = self.ability:GetCooldown(1)
    self.cooldown_remaining = -1
    self:SetStackCount(self.charges_max)

    self.charge_counter_tick = 0.3

    self:StartIntervalThink(self.charge_counter_tick)
end

function modifier_dark_rift_charges:OnDestroy()
    self.parent.dark_rift_mod = nil
end

function modifier_dark_rift_charges:OnIntervalThink()
    self.hidden = not self.parent:HasScepter()

    if self:GetStackCount() < self.charges_max then
        if self.cooldown_remaining == -1 then 
            self.cooldown_remaining = self.charges_cooldown 
            self:SetDuration(self.cooldown_remaining, true)
        end
        self.cooldown_remaining = self.cooldown_remaining - self.charge_counter_tick
        if self.cooldown_remaining <= 0 then
            self:SetStackCount(self:GetStackCount() + 1)
            self.cooldown_remaining = -1
        end
    end
end

function modifier_dark_rift_charges:GetRemainingTime()
    return self.cooldown_remaining
end

function modifier_dark_rift_charges:SpendCharge()
    local current_stacks = self:GetStackCount()
    local new_stacks = current_stacks > 0 and current_stacks - 1 or 0
    self:SetStackCount(new_stacks)

    self.ability:EndCooldown()
    if new_stacks == 0 then
        self.ability:StartCooldown(self.cooldown_remaining or self.charges_cooldown)
    end
end

function modifier_dark_rift_charges:Refresh()
    self:SetStackCount(2)
    self.cooldown_remaining = -1
    self:SetDuration(-1, true)
end

function modifier_dark_rift_charges:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_dark_rift_charges:OnAbilityExecuted(params)
    if params.unit ~= self.parent then return end
    local ability_name = params.ability:GetAbilityName()
    
    if ability_name == "item_refresher" or ability_name == "item_recovery_orb" then
        self:Refresh()
    end
end
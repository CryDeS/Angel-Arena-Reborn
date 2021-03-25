zombie_walking_devouring = class({})
LinkLuaModifier("modifier_zombie_walking_devouring", "creeps/abilities/npc_aa_creep_zombie_walking/modifier_zombie_walking_devouring", LUA_MODIFIER_MOTION_NONE)


function zombie_walking_devouring:OnSpellStart()
    if not IsServer() then return end
    self.damage = self:GetSpecialValueFor("damage")
    self.interval = self:GetSpecialValueFor("interval")
    self.target = self:GetCursorTarget()
    self.done = false
    self.cc_timer = 0
    self.target:AddNewModifier(self:GetCaster(), self, "modifier_zombie_walking_devouring", nil)
end

function zombie_walking_devouring:DealDamage()
    local info = {
        victim = self.target,
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(info)
end

function zombie_walking_devouring:OnChannelThink(fInterval)
    if not IsServer() then return end
    if self.done then return end
    self.cc_timer = self.cc_timer + fInterval
    if self.cc_timer >= self.interval then
        self.cc_timer = self.cc_timer - self.interval
        self:DealDamage()
    end
end


function zombie_walking_devouring:OnChannelFinish(bInterrupted)
    if not IsServer() then return end
    self.target:RemoveModifierByName("modifier_zombie_walking_devouring")
    if not bInterrupted then
        self:DealDamage()
    end
    self.done = true
end


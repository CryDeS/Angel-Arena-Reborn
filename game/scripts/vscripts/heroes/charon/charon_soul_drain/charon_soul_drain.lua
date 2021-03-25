charon_soul_drain = charon_soul_drain or class({})
LinkLuaModifier("modifier_charon_soul_drain", "heroes/charon/charon_soul_drain/modifier_charon_soul_drain", LUA_MODIFIER_MOTION_NONE)

local START_SOUND   = "Hero_Charon.SoulDrain.Cast"
local LOOP_SOUND    = "Hero_Charon.SoulDrain.Loop"
local END_SOUND     = "Hero_Charon.SoulDrain.End"

function charon_soul_drain:IsStealable()
	return true
end

function charon_soul_drain:OnSpellStart()
    if not IsServer() then return end
    self.damage = self:GetSpecialValueFor("damage")
    self.manaburn = self:GetSpecialValueFor("manaburn")
    self.manaburn_pct = self:GetSpecialValueFor("manaburn_pct")
    self.duration = self:GetSpecialValueFor("duration_tooltip")
    local caster = self:GetCaster()

    if caster:HasTalent("charon_soul_drain_cast_time_fast_bonus_const_tallent") then
        local speedBonus = caster:GetTalentSpecialValueFor("charon_soul_drain_cast_time_fast_bonus_const_tallent")
        local mainCastTime = self.duration + speedBonus
        local coef = self.duration/mainCastTime
        self.damage = self.damage*coef
        self.manaburn = self.manaburn*coef
        self.manaburn_pct = self.manaburn_pct*coef
    end

    self.interval = self:GetSpecialValueFor("interval")
    self.target = self:GetCursorTarget()
    self.done = false
    self.cc_timer = 0
    self.target:AddNewModifier(caster, self, "modifier_charon_soul_drain", { duration = self:GetChannelTime() })

    self.particle = ParticleManager:CreateParticle("particles/charon/charon_soul_drain/charon_soul_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

    ParticleManager:SetParticleControlEnt(self.particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

    EmitSoundOn(START_SOUND, caster)
    EmitSoundOn(LOOP_SOUND, caster)
end

function charon_soul_drain:DealDamage()
    local info = {
        victim = self.target,
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
    ApplyDamage(info)
	local parent =self:GetCaster()
	if parent:HasModifier("modifier_charon_passive") or parent:HasModifier("modifier_item_void_stick") then
		parent:Heal(self.damage, self)
	end
end

function charon_soul_drain:ManaBurn()
    if not IsServer() then return end
    local manaburn_full = self.manaburn + self.target:GetMaxMana()/100*self.manaburn_pct
    self.target:ReduceMana(manaburn_full)
	local parent =self:GetCaster()
	if parent:HasModifier("modifier_charon_passive") or parent:HasModifier("modifier_item_void_stick") then
		parent:GiveMana(manaburn_full)
	end
end

function charon_soul_drain:OnChannelThink(fInterval)
    if not IsServer() then return end
    if self.done then return end
    self.cc_timer = self.cc_timer + fInterval
    if self.cc_timer >= self.interval then
        self.cc_timer = self.cc_timer - self.interval
        if self.target:GetMana() > self.manaburn then
            self:ManaBurn()
        else
            self:DealDamage()
        end
    end
end


function charon_soul_drain:OnChannelFinish(bInterrupted)
    if not IsServer() then return end
    self.target:RemoveModifierByName("modifier_charon_soul_drain")
    if not bInterrupted then
        if self.target:GetMana() > self.manaburn then
            self:ManaBurn()
        else
            self:DealDamage()
        end
    end
    self.done = true
    ParticleManager:DestroyParticle(self.particle, false)
    local caster = self:GetCaster()

    StopSoundOn(LOOP_SOUND, caster)
    EmitSoundOn(END_SOUND, caster)
end

function charon_soul_drain:GetChannelTime()
    local casttime
    local caster = self:GetCaster()
    local talentName = "charon_soul_drain_cast_time_fast_bonus_const_tallent"
    casttime = self:GetSpecialValueFor("duration_tooltip")+ caster:GetTalentSpecialValueFor(talentName)
    return casttime
end

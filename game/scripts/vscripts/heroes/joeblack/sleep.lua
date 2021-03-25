joe_black_sleep = class({})
LinkLuaModifier("modifier_joe_black_sleep_self", "heroes/joeblack/modifiers/modifier_joe_black_sleep_self", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_joe_black_sleep", "heroes/joeblack/modifiers/modifier_joe_black_sleep", LUA_MODIFIER_MOTION_NONE)

function joe_black_sleep:GetIntrinsicModifierName()
	return "modifier_joe_black_sleep_self"
end

function joe_black_sleep:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then 
		return 
	end

	local duration = self:GetSpecialValueFor("duration")

	caster:FindModifierByName("modifier_joe_black_sleep_self"):RegisterSleepCast(target)
	
	target:AddNewModifier(caster, self, "modifier_joe_black_sleep", {duration = duration})
end

function joe_black_sleep:OnUpgrade( ... )
	local mod = self:GetCaster():FindModifierByName("modifier_joe_black_sleep_self")
	if mod then
		mod.delay        = self:GetSpecialValueFor("delay")
		mod.health_drain_const = self:GetSpecialValueFor("health_drain_const") * mod.delay
		mod.mana_drain_const   = self:GetSpecialValueFor("mana_drain_const") * mod.delay
		mod.health_drain_pct   = self:GetSpecialValueFor("health_drain_pct") * mod.delay / 100
		mod.mana_drain_pct     = self:GetSpecialValueFor("mana_drain_pct") * mod.delay / 100
	end
end

function joe_black_sleep:OnProjectileHit( hTarget, vLocation )
	if not hTarget then return end
	if hTarget:IsMagicImmune() then return end
	if hTarget:TriggerSpellAbsorb(self) or hTarget:TriggerSpellReflect(self) then 
		return 
	end
	
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_joe_black_sleep", {duration = self:GetSpecialValueFor("duration")})
end
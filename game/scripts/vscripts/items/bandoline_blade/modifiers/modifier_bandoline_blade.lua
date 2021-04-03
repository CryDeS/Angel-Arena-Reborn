require('items/second_attacks')

modifier_bandoline_blade = modifier_bandoline_blade or class({})

local mod = modifier_bandoline_blade

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 = ability:GetSpecialValueFor("bonus_as")
	self.bonusStats  = ability:GetSpecialValueFor("bonus_stats")

	if not IsServer() then return end

	self.attackDelay = ability:GetSpecialValueFor("attack_delay")
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy()
	if not IsServer() then return end

	local timer = self.timer

	if timer ~= nil then
		Timers:RemoveTimer(timer)
		self.timer = nil
	end
end

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:OnAttackLanded(params)
	if not IsServer() then return end

	local parent = self:GetParent()
	local target = params.target

	if not parent or parent ~= params.attacker or not target then return end

	local ability = self:GetAbility()

	if not ability then return end

	if parent:IsIllusion() or parent:IsRangedAttacker() then return end

	if not target:IsAlive() or not parent:IsAlive() then return end

	if not ability:IsCooldownReady() then return end

	if not MeleeSecondAttack:CanSecondAttack(parent) then return end

	ability:UseResources(false, false, true)
	parent:AddNewModifier(parent, ability, "modifier_bandoline_blade_cd", { duration = ability:GetCooldownTimeRemaining() })

	local timer = self.timer

	if timer ~= nil then
		Timers:RemoveTimer(timer)
	end

	self.timer = Timers:CreateTimer( self.attackDelay, function()
		parent:PerformAttack(target, true, true, true, true, true, false, false)
	end)
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end

function mod:GetModifierBonusStats_Strength( ... )
	return self.bonusStats
end

mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Agility   = mod.GetModifierBonusStats_Strength
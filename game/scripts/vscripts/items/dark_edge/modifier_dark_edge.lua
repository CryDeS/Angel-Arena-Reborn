require('lib/resistances')

modifier_dark_edge = modifier_dark_edge or class({})
local mod = modifier_dark_edge

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonusStats	 = ability:GetSpecialValueFor("bonus_stats")
	self.bonusHp 	 = ability:GetSpecialValueFor("bonus_hp")

	if not IsServer() then return end

	self.lifesteal 	 = ability:GetSpecialValueFor("lifesteal") / 100
	self.attackDelay = ability:GetSpecialValueFor("attack_delay")
	self.attackCd 	 = ability:GetSpecialValueFor("attack_cd")
end

mod.OnRefresh = mod.OnCreated

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end

function mod:GetModifierHealthBonus()
	return self.bonusHp
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStats
end

mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Agility   = mod.GetModifierBonusStats_Strength

function mod:OnAttackLanded(params)
	if not IsServer() then return end

	local parent = self:GetParent()
	local target = params.target

	if not parent or parent ~= params.attacker or not target then return end

	local ability = self:GetAbility()

	if not ability then return end

	if not target:IsAlive() or not parent:IsAlive() then return end

	if not parent:IsIllusion() and not parent:IsRangedAttacker() and MeleeSecondAttack:CanSecondAttack(parent) then
		local cd = self.attackCd * parent:GetCooldownReduction()

		parent:AddNewModifier(parent, ability, "modifier_dark_edge_cd", { duration = cd })

		local timer = self.timer

		if timer ~= nil then
			Timers:RemoveTimer(timer)
		end

		self.timer = Timers:CreateTimer( self.attackDelay, function()
			if not ability or ability:IsNull() then return end
			if not parent or parent:IsNull() then return end
			if not target or target:IsNull() then return end

			parent:PerformAttack(target, true, true, true, true, true, false, false)
		end)
	end

	if target:IsBuilding() then return end

	local damage = params.damage

	local ursaSwipesModifierName = "modifier_ursa_fury_swipes_damage_increase"

	if parent:GetName() == "npc_dota_hero_ursa" and target:HasModifier(ursaSwipesModifierName)then
		local swapsAbility		  = parent:GetAbilityByIndex(2)
		local damagePerSwap		  = swapsAbility:GetSpecialValueFor("damage_per_stack")
		local stacks			  = target:GetModifierStackCount(ursaSwipesModifierName, parent)
		local bonusDamagePerSwaps = stacks * damagePerSwap

		damage = damage + bonusDamagePerSwaps
	end

	damage = damage - damage * Resistances:GetArmorDecrease( target )

	local heal = self.lifesteal * damage

	parent:Heal(heal, self)

	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
	ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
	SendOverheadEventMessage(parent, OVERHEAD_ALERT_HEAL, parent, heal, nil)
end
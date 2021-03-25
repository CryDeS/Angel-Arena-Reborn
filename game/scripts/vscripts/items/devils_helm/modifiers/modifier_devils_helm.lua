modifier_devils_helm = modifier_devils_helm or class({})
local mod = modifier_devils_helm

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
	self.bonusStr 	 = ability:GetSpecialValueFor("bonus_str")
	self.bonusResist = ability:GetSpecialValueFor("bonus_status_resist")

	if not IsServer() then return end

	self.disarmorDuration = ability:GetSpecialValueFor("disarmor_duration")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function mod:OnAttackLanded(params)
	if not IsServer() then return end

	local parent = self:GetParent()
	local target = params.target

	if not parent or parent ~= params.attacker or not target then return end

	local ability = self:GetAbility()

	if not ability then return end

	if not target:IsAlive() or not parent:IsAlive() then return end

	target:AddNewModifier(parent, ability, "modifier_devils_helm_debuff", { duration = self.disarmorDuration })
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr
end

function mod:GetModifierStatusResistanceStacking(params)
	return self.bonusResist
end
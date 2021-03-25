modifier_devour_helm = modifier_devour_helm or class({})
local mod = modifier_devour_helm

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:GetModifierAura()
	return "modifier_devour_helm_aura"
end

function mod:IsAura()
	return true
end

function mod:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function mod:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function mod:GetAuraRadius()
	return self.radius or 0
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.radius 	= ability:GetSpecialValueFor("aura_radius")
	self.damage 	= ability:GetSpecialValueFor("damage")
	self.bonusAs 	= ability:GetSpecialValueFor("attack_speed")
	self.bonusStats = ability:GetSpecialValueFor("bonus_stats")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}
end

function mod:GetModifierPreAttack_BonusDamage( params )
	return self.damage or 0
end

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonusAs or 0
end

function mod:GetModifierBonusStats_Strength( params )
	return self.bonusStats or 0
end

mod.GetModifierBonusStats_Agility 	= mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength
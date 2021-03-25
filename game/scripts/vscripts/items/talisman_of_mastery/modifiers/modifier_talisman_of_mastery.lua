require('lib/common_abilities/damage_to_exp')

modifier_talisman_of_mastery = CommonAbilities:ConstructModifier( modifier_talisman_of_mastery, CommonAbilities.DamageToExp )

local mod = modifier_talisman_of_mastery

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusHpReg  = ability:GetSpecialValueFor("bonus_hp_regen")
	self.bonusStr    = ability:GetSpecialValueFor("bonus_str")
	self.bonusAttack = ability:GetSpecialValueFor("bonus_attack")

	self:CommonInitDamageToExp( ability, ability:GetCooldown( ability:GetLevel() - 1 ) )
end

mod.OnRefresh = mod.OnRefresh

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function mod:OnTakeDamage( params )
	if not IsServer() then return end

	local parent = self:GetParent()

	if params.attacker ~= parent then return end

	local target = params.unit

	if not target:IsRealHero() or target:GetTeamNumber() == parent:GetTeamNumber() then return end

	local ability = self:GetAbility()

	if self:ProcessDamageToExp( parent, ability, params.damage ) then
		ability:UseResources(false, false, true)
	end
end

function mod:GetModifierConstantHealthRegen( params )
	return self.bonusHpReg
end

function mod:GetModifierBonusStats_Strength( params )
	return self.bonusStr
end

function mod:GetModifierPreAttack_BonusDamage( params )
	return self.bonusAttack
end
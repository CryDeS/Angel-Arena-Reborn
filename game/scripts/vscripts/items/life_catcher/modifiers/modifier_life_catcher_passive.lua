require('lib/common_abilities/damage_to_exp')

modifier_life_catcher_passive = CommonAbilities:ConstructModifier( modifier_life_catcher_passive, CommonAbilities.DamageToExp )

local mod = modifier_life_catcher_passive

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusStr 	= ability:GetSpecialValueFor("bonus_str")
	self.bonusInt 	= ability:GetSpecialValueFor("bonus_int")
	self.bonusHpReg = ability:GetSpecialValueFor("bonus_hpregen")
	self.bonusMpReg = ability:GetSpecialValueFor("bonus_manaregen")
	self.bonusDmg 	= ability:GetSpecialValueFor("bonus_damage")
	self.bonusSpellAmp = ability:GetSpecialValueFor("spell_amp")

	self:CommonInitDamageToExp( ability )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function mod:OnTakeDamage( params )
	if not IsServer() then return end

	local parent = self:GetParent()

	if params.attacker ~= parent then return end

	local target = params.unit
	
	if not target:IsRealHero() or target:GetTeamNumber() == parent:GetTeamNumber() then return end

	self:ProcessDamageToExp( parent, self:GetAbility(), params.damage )
end

function mod:GetModifierBonusStats_Strength( params )
	return self.bonusStr
end

function mod:GetModifierBonusStats_Intellect( params )
	return self.bonusInt
end 

function mod:GetModifierConstantHealthRegen( params )
	return self.bonusHpReg
end 

function mod:GetModifierConstantManaRegen( params )
	return self.bonusMpReg
end 

function mod:GetModifierPreAttack_BonusDamage( params )
	return self.bonusDmg
end 
function mod:GetModifierSpellAmplify_Percentage( params )
	return self.bonusSpellAmp
end
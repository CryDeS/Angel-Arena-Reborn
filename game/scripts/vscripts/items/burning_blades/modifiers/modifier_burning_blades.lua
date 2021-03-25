modifier_burning_blades = modifier_burning_blades or class({})
local mod = modifier_burning_blades

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
	self.bonusMs 	 = ability:GetSpecialValueFor("bonus_ms")
	self.bonusAgi    = ability:GetSpecialValueFor("bonus_agi")
	self.bonusStr    = ability:GetSpecialValueFor("bonus_str")
	self.bonusResist = ability:GetSpecialValueFor("bonus_status_resist")

	if not IsServer() then return end

	self.maimChance   	  = ability:GetSpecialValueFor("maim_chance")
	self.maimDuration 	  = ability:GetSpecialValueFor("maim_duration")
	self.maimDamage   	  = ability:GetSpecialValueFor("maim_damage")
	self.disarmorDuration = ability:GetSpecialValueFor("disarmor_duration")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
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

	if self.stream:RollPercentage( self.maimChance ) then
		target:AddNewModifier(parent, ability, "modifier_burning_blades_maim", { duration = self.maimDuration })
		
		if parent:IsRealHero() then
			ApplyDamage({
				victim 		= target,
				attacker 	= parent,
				ability 	= ability,
				damage 		= self.maimDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
		end

		target:EmitSound("Item_BurningBlades.Maim")
	end

	target:AddNewModifier(parent, ability, "modifier_burning_blades_disarmor", { duration = self.disarmorDuration })
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end

function mod:GetModifierBonusStats_Agility()
	return self.bonusAgi
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr
end

function mod:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonusMs
end

function mod:GetModifierStatusResistanceStacking(params)
	return self.bonusResist
end
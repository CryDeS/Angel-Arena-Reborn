require('items/ranged_splash')

modifier_burning_book = modifier_burning_book or class({})

local mod = RangedSplashModifier:ApplyToModifier(modifier_burning_book)

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusInt    = ability:GetSpecialValueFor("bonus_int")
	self.bonusStr    = ability:GetSpecialValueFor("bonus_str")
	self.bonusAgi    = ability:GetSpecialValueFor("bonus_agi")
	self.bonusAs     = ability:GetSpecialValueFor("bonus_as")
	self.bonusMs 	 = ability:GetSpecialValueFor("bonus_ms")
	self.bonusHpReg  = ability:GetSpecialValueFor("bonus_hp_regen")
	self.bonusResist = ability:GetSpecialValueFor("bonus_status_resist")

	if not IsServer() then return end

	local splashDamage = ability:GetSpecialValueFor("splash_pct") / 100
	local splashRadius = ability:GetSpecialValueFor("splash_radius")

	self:Init(splashDamage, splashRadius)

	self.maimChance   	  = ability:GetSpecialValueFor("maim_chance")
	self.maimDuration 	  = ability:GetSpecialValueFor("maim_duration")
	self.maimDamage   	  = ability:GetSpecialValueFor("maim_damage")
	self.disarmorDuration = ability:GetSpecialValueFor("disarmor_duration")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr
end

function mod:GetModifierBonusStats_Agility()
	return self.bonusAgi
end

function mod:GetModifierBonusStats_Intellect()
	return self.bonusInt
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end

function mod:GetModifierConstantHealthRegen()
	return self.bonusHpReg
end

function mod:GetModifierStatusResistanceStacking(params)
	return self.bonusResist
end

function mod:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonusMs
end

function mod:OnAttackLanded(params)
	if not IsServer() then return end

	local parent = self:GetParent()

	if parent ~= params.attacker then return end

	local target = params.target
	local ability = self:GetAbility()

	if not target or target:IsNull() or not IsValidEntity(target) or not ability or ability:IsNull() then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	if self.stream:RollPercentage( self.maimChance ) then
		target:AddNewModifier(parent, ability, "modifier_burning_book_maim", { duration = self.maimDuration })
		
		if parent:IsRealHero() then
			ApplyDamage({
				victim 		= target,
				attacker 	= parent,
				ability 	= ability,
				damage 		= self.maimDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
		end

		target:EmitSound("Item_BurningBook.Maim")
	end

	target:AddNewModifier(parent, ability, "modifier_burning_book_disarmor", { duration = self.disarmorDuration })

	self:PerformSplash(parent, target, ability, params.damage)
end
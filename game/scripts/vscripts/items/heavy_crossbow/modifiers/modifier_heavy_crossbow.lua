modifier_heavy_crossbow = modifier_heavy_crossbow or class({})
local mod = modifier_heavy_crossbow

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated( kv )
	local ability = self:GetAbility()
	
	if not ability then return end

	self.bonusDamage 	  = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 	  = ability:GetSpecialValueFor("bonus_as")
	self.hp 		 	  = ability:GetSpecialValueFor("bonus_hp")
	self.bonusStats  	  = ability:GetSpecialValueFor("bonus_stats")
	self.bonusAttackRange = ability:GetSpecialValueFor("bonus_attack_range")

	if not IsServer() then return end

	self.critChance  = ability:GetSpecialValueFor("crit_chance")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )
end

function mod:OnDestroy()
	local mod = self.mod
	
	if mod then
		self.mod = nil

		if not mod:IsNull() then
			mod:Destroy()
		end
	end	
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:GetModifierPreAttack_BonusDamage( params )
	return self.bonusDamage
end

function mod:GetModifierBonusStats_Strength( params )
	return self.bonusStats
end

mod.GetModifierBonusStats_Agility 	= mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonusAs
end

function mod:GetModifierHealthBonus( params )
	return self.hp
end

function mod:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self.bonusAttackRange
	end

	return 0
end

function mod:OnAttackStart( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = params.target

	if not ability or ability:IsNull() or parent ~= params.attacker then return end

	if not parent or parent:IsNull() then return end
	if not target or target:IsNull() then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	if self.stream:RollPercentage( self.critChance ) then
		self.mod = parent:AddNewModifier(parent, ability, "modifier_heavy_crossbow_crit", { duration = -1 })
	end
end

function mod:OnAttackLanded( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	if parent ~= params.attacker then return end

	local mod = self.mod
	
	if mod then
		self.mod = nil

		if not mod:IsNull() then
			mod:Destroy()
		end
	end
end
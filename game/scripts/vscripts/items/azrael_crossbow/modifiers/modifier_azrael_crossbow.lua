modifier_azrael_crossbow = modifier_azrael_crossbow or class({})
local mod = modifier_azrael_crossbow

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated( kv )
	if not self or self:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.bonusDamage 	  = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 	  = ability:GetSpecialValueFor("bonus_as")
	self.bonusStats  	  = ability:GetSpecialValueFor("bonus_stats")
	self.bonusHpReg  	  = ability:GetSpecialValueFor("bonus_hpreg")
	self.hp 			  = ability:GetSpecialValueFor("bonus_hp")
	self.bonusAttackRange = ability:GetSpecialValueFor("bonus_attack_range")

	if not IsServer() then return end

	self.critChance  = ability:GetSpecialValueFor("crit_chance")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )

	self.attacks = {}
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
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_EVENT_ON_ATTACK_FAIL,
}
end

function mod:GetModifierPreAttack_BonusDamage( params )
	return self.bonusDamage or 0
end

function mod:GetModifierBonusStats_Strength( params )
	return self.bonusStats or 0
end

mod.GetModifierBonusStats_Agility 	= mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonusAs or 0
end

function mod:GetModifierConstantHealthRegen( params )
	return self.bonusHpReg or 0
end

function mod:GetModifierHealthBonus( params )
	return self.hp or 0
end

function mod:GetModifierAttackRangeBonus()
	if not self or self:IsNull() then return 0 end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return 0 end

	if parent:IsRangedAttacker() then
		return self.bonusAttackRange or 0
	end

	return 0
end

function mod:OnAttackRecord( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	if self:GetParent() ~= params.attacker then return end

	if self.handleID then
		self.attacks[params.record] = 1
	end
end

function mod:OnAttackStart( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local ability = self:GetAbility()
	
	if not ability or ability:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	local target = params.target

	if not target or target:IsNull() then return end

	if parent ~= params.attacker then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	if self.stream:RollPercentage( self.critChance ) then
		self.mod = parent:AddNewModifier(parent, ability, "modifier_azrael_crossbow_crit", { duration = -1 })
	end
end

function mod:OnAttackLanded( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	local target = params.target

	if not target or target:IsNull() then return end

	if parent ~= params.attacker then return end

	-- must delete secondary attack there, because we can cause memleak if dont delete when parent/target is dead
	local myAttackID = params.record

	local isSecondaryAttack = self.attacks[ myAttackID ] ~= nil

	self.attacks[ myAttackID ] = nil

	-- but apply any options if parent or target is dead is not our choice
	if not parent:IsAlive() or not target:IsAlive() then return end

	local mod = self.mod
	
	if mod then
		self.mod = nil

		if not mod:IsNull() then
			mod:Destroy()
		end
	end	

	if not parent:IsRangedAttacker() then return end

	if not isSecondaryAttack then
		if parent:HasModifier("modifier_azrael_crossbow_cd") then return end

		parent:AddNewModifier(parent, ability, "modifier_azrael_crossbow_cd", { duration = ability:GetSpecialValueFor("attack_cd") })

		local falseAttack = false
		local useProj = true

		self.handleID = true
		parent:PerformAttack(target, false, true, true, true, useProj, falseAttack, true) 
		self.handleID = false
	end
end

function mod:OnAttackFail( params )
	if not IsServer() then return end
	if not self or self:IsNull() then return end

	self.attacks[ params.record ] = nil
end

modifier_doombolt = modifier_doombolt or class({})
local mod = modifier_doombolt

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated( kv )
	local ability = self:GetAbility()
	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 = ability:GetSpecialValueFor("bonus_as")
	self.bonusStats  = ability:GetSpecialValueFor("bonus_stats")

	if not IsServer() then return end

	self.critChance  = ability:GetSpecialValueFor("crit_chance")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy()
	local mod = self.mod
	
	if mod then
		self.mod = nil

		if not mod:IsNull() then
			mod:Destroy()
		end
	end	
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
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

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonusAs
end

mod.GetModifierBonusStats_Agility 	= mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength

function mod:OnAttackStart( params )
	if not IsServer() then return end
	if not self or self:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end
	
	local target = params.target

	if not target or target:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() or parent ~= params.attacker then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	if self.stream:RollPercentage( self.critChance ) then
		self.mod = parent:AddNewModifier(parent, ability, "modifier_doombolt_crit", { duration = -1 })
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
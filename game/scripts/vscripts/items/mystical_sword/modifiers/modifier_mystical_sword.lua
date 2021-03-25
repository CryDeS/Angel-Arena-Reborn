modifier_mystical_sword = modifier_mystical_sword or class({})
local mod = modifier_mystical_sword

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
	self.bonusAgi    = ability:GetSpecialValueFor("bonus_agi")

	if not IsServer() then return end

	self.maimChance   = ability:GetSpecialValueFor("maim_chance")
	self.maimDuration = ability:GetSpecialValueFor("maim_duration")
	self.maimDamage   = ability:GetSpecialValueFor("maim_damage")

	self.stream = CreateUniformRandomStream( GameRules:GetGameTime() )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
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
		target:AddNewModifier(parent, ability, "modifier_mystical_sword_debuff", { duration = self.maimDuration })
		
		if parent:IsRealHero() then
			ApplyDamage({
				victim 		= target,
				attacker 	= parent,
				ability 	= ability,
				damage 		= self.maimDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
			})
		end

		target:EmitSound("Item_MysticalSword.Maim")
	end
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
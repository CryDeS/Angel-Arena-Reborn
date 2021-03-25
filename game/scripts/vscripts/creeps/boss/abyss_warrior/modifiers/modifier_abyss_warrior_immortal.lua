modifier_abyss_warrior_immortal = modifier_abyss_warrior_immortal or class({})

local mod = modifier_abyss_warrior_immortal

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.hpLossMult  = ability:GetSpecialValueFor("hp_loss_pct") / 100

	self.attackSpeed = ability:GetSpecialValueFor("attack_speed")
	self.hpRegen 	 = ability:GetSpecialValueFor("hp_reg")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function mod:GetMultiplier()
	local parent = self:GetParent()

	local hpLossed = 1 - parent:GetHealthPercent() / 100

	return hpLossed / self.hpLossMult
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.attackSpeed * self:GetMultiplier()
end

function mod:GetModifierConstantHealthRegen()
	return self.hpRegen * self:GetMultiplier()
end

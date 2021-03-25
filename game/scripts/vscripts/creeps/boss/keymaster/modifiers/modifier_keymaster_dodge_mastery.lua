modifier_keymaster_dodge_mastery = modifier_keymaster_dodge_mastery or class({})
local mod = modifier_keymaster_dodge_mastery

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	if IsServer() then
		self.radius = ability:GetCastRange( parent:GetAbsOrigin(), nil) + parent:GetCastRangeBonus()
	end
	
	self.aspeedPerHP = ability:GetSpecialValueFor("aspeed_per_hp_pct")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function mod:GetMultiplier()
	local parent = self:GetParent()

	if not parent or parent:IsNull() then return 0 end
	
	local hpLossed = 100 - parent:GetHealthPercent()

	return hpLossed
end

function mod:GetModifierAttackSpeedBonus_Constant()
	if not self or self:IsNull() then return 0 end

	return self.aspeedPerHP * self:GetMultiplier()
end

function mod:OnTakeDamage( params )
	if not IsServer() then return end

	local parent = params.unit

	if parent ~= self:GetParent() then return end
	
	if not parent or parent:IsNull() then return end

	local attacker = params.attacker

	if not attacker or attacker:IsNull() then return end

	local damage = params.damage

	if not attacker or (attacker:GetAbsOrigin() - parent:GetAbsOrigin()):Length() > self.radius then
		parent:SetHealth( parent:GetHealth() + damage )
	end

	-- Marshall to AI info about taking some damage
	if parent.ai then
		parent.ai:OnTakeDamage( attacker, damage )
	end
end
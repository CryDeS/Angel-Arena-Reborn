modifier_keymaster_damned_souls_debuff = modifier_keymaster_damned_souls_debuff or class({})
local mod = modifier_keymaster_damned_souls_debuff

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return true end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.attackSpeedDebuff
end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.attackSpeedDebuff = -ability:GetSpecialValueFor("attack_speed_debuff")
end
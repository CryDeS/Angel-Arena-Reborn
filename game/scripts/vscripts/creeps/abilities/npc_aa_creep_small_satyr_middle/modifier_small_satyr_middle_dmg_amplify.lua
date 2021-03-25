modifier_small_satyr_middle_dmg_amplify = modifier_small_satyr_middle_dmg_amplify or class({})
local mod = modifier_small_satyr_middle_dmg_amplify

function mod:IsHidden()
    return false
end

function mod:IsDebuff()
    return false
end

function mod:IsPurgable()
    return false
end

function mod:DestroyOnExpire()
    return true
end

function mod:DeclareFunctions() return
{
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
}
end

function mod:GetModifierBaseDamageOutgoing_Percentage()
    return self.percent
end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

    self.percent = ability:GetSpecialValueFor("damage_pct")
end

mod.OnRefresh = mod.OnCreated
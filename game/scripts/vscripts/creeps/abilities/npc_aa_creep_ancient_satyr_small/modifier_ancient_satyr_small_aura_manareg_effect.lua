modifier_ancient_satyr_small_aura_manareg_effect = modifier_ancient_satyr_small_aura_manareg_effect or class({})
local mod = modifier_ancient_satyr_small_aura_manareg_effect

--------------------------------------------------------------------------------
function mod:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function mod:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function mod:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function mod:DestroyOnExpire()
    return true
end

------------------------------------------------------------------------------
function mod:DeclareFunctions() return
{
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end

--------------------------------------------------------------------------------
function mod:GetModifierConstantManaRegen()
    return self.mana_regen
end

--------------------------------------------------------------------------------
function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

    self.mana_regen = ability:GetSpecialValueFor("mana_regen")
end

mod.OnRefresh = mod.OnCreated
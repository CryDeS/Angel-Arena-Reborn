modifier_item_restoration_bracer = modifier_item_restoration_bracer or class({})
local mod = modifier_item_restoration_bracer

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusHpReg  = ability:GetSpecialValueFor("bonus_hp_regen")
	self.bonusMpReg  = ability:GetSpecialValueFor("bonus_mpreg")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end

function mod:GetModifierConstantHealthRegen()
	return self.bonusHpReg
end

function mod:GetModifierConstantManaRegen()
	return self.bonusMpReg 
end
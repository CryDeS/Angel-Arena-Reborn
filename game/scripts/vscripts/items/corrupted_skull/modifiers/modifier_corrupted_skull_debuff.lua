modifier_corrupted_skull_debuff = modifier_corrupted_skull_debuff or class({})
local mod = modifier_corrupted_skull_debuff

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return true end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.disarmor = -ability:GetSpecialValueFor("disarmor")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function mod:GetModifierPhysicalArmorBonus(kv)        
	return self.disarmor
end 
modifier_forgotten_hero_combat_mastery_disarmor = modifier_forgotten_hero_combat_mastery_disarmor or class({})
local mod = modifier_forgotten_hero_combat_mastery_disarmor

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return true end
function mod:IsPurgable() 	 	return true end
function mod:DestroyOnExpire()  return true  end
function mod:IsPurgeException() return true  end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.disarmor = -ability:GetSpecialValueFor("disarmor")
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function mod:GetModifierPhysicalArmorBonus()
	return self.disarmor * self:GetStackCount()
end

function mod:GetEffectName()
	return "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_solar_forge_ambient.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

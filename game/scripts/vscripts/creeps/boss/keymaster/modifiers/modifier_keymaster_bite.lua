modifier_keymaster_bite = modifier_keymaster_bite or class({})
local mod = modifier_keymaster_bite

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return true end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
}
end

function mod:GetModifierPhysicalArmorBonus(kv)        
	return self.disarmor
end 


function mod:GetModifierTotalDamageOutgoing_Percentage()
	return self.damageModifier
end

function mod:OnCreated(kv)
	if not self or self:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.disarmor 		= -ability:GetSpecialValueFor("disarmor")
	self.damageModifier = -ability:GetSpecialValueFor("damage_reduction")
end
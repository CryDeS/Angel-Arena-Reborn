modifier_damned_swords_debuff = modifier_damned_swords_debuff or class({})
local mod = modifier_damned_swords_debuff

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.slowAs = -ability:GetSpecialValueFor("maim_decrease_as")
	self.slowMs = -ability:GetSpecialValueFor("maim_decrease_ms")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function mod:GetModifierMoveSpeedBonus_Percentage( params )
	return self.slowMs
end

function mod:GetModifierAttackSpeedBonus_Constant( params )
	return self.slowAs
end


function mod:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_gun_joe_calibrated_shot_buff = modifier_gun_joe_calibrated_shot_buff or class({})
mod = modifier_gun_joe_calibrated_shot_buff

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return false end

function mod:OnCreated( kv )
	local ability = self:GetAbility()
	
	if not ability or ability:IsNull() then return end

	self.damageMultiplier = ability:GetSpecialValueFor( "damage_from_attack" )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
}
end

function mod:GetModifierTotalDamageOutgoing_Percentage( params )
	return self.damageMultiplier
end
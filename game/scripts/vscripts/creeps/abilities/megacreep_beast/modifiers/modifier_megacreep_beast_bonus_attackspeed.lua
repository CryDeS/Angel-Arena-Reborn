modifier_megacreep_beast_bonus_attackspeed = class({}) or modifier_megacreep_beast_bonus_attackspeed

--------------------------------------------------------------------------------

function modifier_megacreep_beast_bonus_attackspeed:IsDebuff() 		return false end
function modifier_megacreep_beast_bonus_attackspeed:IsHidden() 		return false end
function modifier_megacreep_beast_bonus_attackspeed:IsPurgable() 	return true end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_bonus_attackspeed:GetEffectName()
    return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_bonus_attackspeed:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_megacreep_beast_bonus_attackspeed:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end 

function modifier_megacreep_beast_bonus_attackspeed:OnCreated()
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed")
end 

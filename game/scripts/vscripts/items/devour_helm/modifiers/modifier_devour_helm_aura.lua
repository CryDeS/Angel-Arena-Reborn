modifier_devour_helm_aura = modifier_devour_helm_aura or class({})
local mod = modifier_devour_helm_aura

function mod:IsHidden()         return false  end
function mod:IsDebuff()       	return false end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetTexture()
	return "../items/devour_helm_big"
end

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function mod:OnCreated()
	local ability = self:GetAbility()
	
	if not ability then return end

	self.bonusAs 	= ability:GetSpecialValueFor("attack_speed_aura")
	self.bonusHpReg = ability:GetSpecialValueFor("hp_regen_aura")
end

mod.OnRefresh = mod.OnCreated

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs or 0
end

function mod:GetModifierConstantHealthRegen()
	return self.bonusHpReg or 0
end
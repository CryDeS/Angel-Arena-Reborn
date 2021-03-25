modifier_soul_guardian_heavy_strike_slow = modifier_soul_guardian_heavy_strike_slow or class({})
local mod = modifier_soul_guardian_heavy_strike_slow

function mod:IsHidden()         return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:RemoveOnDeath() 	return true	 end
function mod:IsDebuff() 		return true	 end

function mod:OnCreated()
	self.knockback_slow_pct = self:GetAbility():GetSpecialValueFor("knockback_slow_pct")
end

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function mod:GetModifierMoveSpeedBonus_Percentage()
    return -(self.knockback_slow_pct)
end

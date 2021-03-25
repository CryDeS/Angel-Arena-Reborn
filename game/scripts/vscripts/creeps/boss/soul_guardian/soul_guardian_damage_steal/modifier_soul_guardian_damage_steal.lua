modifier_soul_guardian_damage_steal = modifier_soul_guardian_damage_steal or class({})
local mod = modifier_soul_guardian_damage_steal

function mod:IsHidden()         return false  end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:IsDebuff() 		return true end
function mod:RemoveOnDeath()	return true end

--------------------------------------------------------------------------------
function mod:IsHidden()
	return false
end

--------------------------------------------------------------------------------
function mod:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
function mod:IsDebuff()
	return true
end

--------------------------------------------------------------------------------
function mod:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function mod:DestroyOnExpire()
	return true
end

-------------------------------------------------------------------------------
function mod:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function mod:GetModifierPreAttack_BonusDamage()
    return -self:GetStackCount()
end

----------------------------------------------------------------------------

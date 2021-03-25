modifier_azrael_crossbow_cd = modifier_azrael_crossbow_cd or class({})
local mod = modifier_azrael_crossbow_cd

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
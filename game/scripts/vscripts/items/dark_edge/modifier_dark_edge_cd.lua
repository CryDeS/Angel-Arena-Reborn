modifier_dark_edge_cd = modifier_dark_edge_cd or class({})

local mod = modifier_dark_edge_cd

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

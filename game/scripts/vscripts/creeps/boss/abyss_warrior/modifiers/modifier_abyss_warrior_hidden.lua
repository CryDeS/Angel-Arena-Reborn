modifier_abyss_warrior_hidden = modifier_abyss_warrior_hidden or class({})

local mod = modifier_abyss_warrior_hidden

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:GetStatusEffectName()
    return "particles/abyss_warrior/abyss_warrior_status_effect.vpcf"
end

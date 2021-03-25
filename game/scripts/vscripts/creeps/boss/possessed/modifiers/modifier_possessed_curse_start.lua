modifier_possessed_curse_start = modifier_possessed_curse_start or class({})
local mod = modifier_possessed_curse_start

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return true end
function mod:DestroyOnExpire()  return true  end
function mod:IsPurgable() 	 	return false end
function mod:IsPurgeException() return false  end

function mod:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW 
end

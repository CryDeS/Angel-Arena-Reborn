modifier_keymaster_howl_silence = modifier_keymaster_howl_silence or class({})
local mod = modifier_keymaster_howl_silence

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:CheckState() return
{
	[MODIFIER_STATE_SILENCED] 	= true,
	[MODIFIER_STATE_MUTED] 		= true,
}
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_curse.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

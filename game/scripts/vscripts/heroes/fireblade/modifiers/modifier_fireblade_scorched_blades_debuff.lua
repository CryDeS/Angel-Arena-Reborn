modifier_fireblade_scorched_blades_debuff = modifier_fireblade_scorched_blades_debuff or class({})
local mod = modifier_fireblade_scorched_blades_debuff

function mod:IsHidden()         return false end
function mod:IsDebuff()         return true end
function mod:IsPurgable()       return true end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgeException() return true end

function mod:CheckState() return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
}
end

function mod:GetEffectName()
	return "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
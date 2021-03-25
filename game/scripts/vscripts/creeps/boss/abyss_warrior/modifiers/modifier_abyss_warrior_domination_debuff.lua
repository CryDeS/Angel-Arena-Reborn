modifier_abyss_warrior_domination_debuff = modifier_abyss_warrior_domination_debuff or class({})
local mod = modifier_abyss_warrior_domination_debuff

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:CheckState() return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
}
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_disarm.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

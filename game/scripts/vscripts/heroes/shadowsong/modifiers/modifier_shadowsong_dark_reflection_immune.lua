modifier_shadowsong_dark_reflection_immune = modifier_shadowsong_dark_reflection_immune or class({})
local mod = modifier_shadowsong_dark_reflection_immune

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:CheckState() return 
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
}
end

function mod:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function mod:GetEffectAttachType() 
	return PATTACH_ABSORIGIN_FOLLOW 
end
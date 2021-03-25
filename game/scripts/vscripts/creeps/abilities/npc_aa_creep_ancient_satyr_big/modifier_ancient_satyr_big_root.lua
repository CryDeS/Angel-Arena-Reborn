modifier_ancient_satyr_big_root = modifier_ancient_satyr_big_root or class({})

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_root:IsDebuff()	return true end
function modifier_ancient_satyr_big_root:IsHidden()	return false end
function modifier_ancient_satyr_big_root:IsPurgable() return true end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_root:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_earthbind.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_root:GetEffectAttachType()
    return PATTACH_ABSORIGIN
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_root:CheckState() return 
{
	[MODIFIER_STATE_ROOTED] = true,
} end
modifier_megacreep_beast_haste = class({}) or modifier_megacreep_beast_haste

--------------------------------------------------------------------------------

function modifier_megacreep_beast_haste:IsDebuff() 	return false end
function modifier_megacreep_beast_haste:IsHidden() 	return false end

--------------------------------------------------------------------------------

function modifier_megacreep_beast_haste:GetEffectName()
    return "particles/econ/items/weaver/weaver_immortal_ti7/weaver_swarm_infected_debuff_ti7_ground_rings.vpcf"
end

function modifier_megacreep_beast_haste:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end 

--------------------------------------------------------------------------------
function modifier_megacreep_beast_haste:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
}
end

function modifier_megacreep_beast_haste:GetModifierMoveSpeed_AbsoluteMin()
	return 550
end 


--------------------------------------------------------------------------------

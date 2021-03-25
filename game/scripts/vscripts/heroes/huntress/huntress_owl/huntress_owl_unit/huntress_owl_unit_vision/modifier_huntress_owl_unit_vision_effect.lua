modifier_huntress_owl_unit_vision_effect = modifier_huntress_owl_unit_vision_effect or class({})

function modifier_huntress_owl_unit_vision_effect:CheckState()
	if self:GetParent():GetUnitName() == "npc_dota_techies_land_mine" then
		return {}
	else 
		return { [MODIFIER_STATE_INVISIBLE] = false }
	end 
end

function modifier_huntress_owl_unit_vision_effect:IsHidden()
	return true
end

function modifier_huntress_owl_unit_vision_effect:IsPurgable()
	return false
end

function modifier_huntress_owl_unit_vision_effect:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

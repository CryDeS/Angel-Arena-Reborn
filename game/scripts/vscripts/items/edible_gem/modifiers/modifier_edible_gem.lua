if modifier_edible_gem == nil then modifier_edible_gem = class({}) end

function modifier_edible_gem:CheckState()
	if self:GetParent():GetUnitName() == "npc_dota_techies_land_mine" then
		return {}
	else 
		return { [MODIFIER_STATE_INVISIBLE] = false }
	end 
end

function modifier_edible_gem:IsHidden()
	return true
end

function modifier_edible_gem:IsPurgable()
	return false
end

function modifier_edible_gem:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

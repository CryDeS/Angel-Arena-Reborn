modifier_satan_overpain_active = class({})

function modifier_satan_overpain_active:IsPurgable()
	return false
end

function modifier_satan_overpain_active:GetEffectName()
	return "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner.vpcf"
end

function modifier_satan_overpain_active:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_satan_overpain_active:OnCreated()
	local ability = self:GetAbility()
	if IsServer() then
		self.damage_reduction = ability:GetSpecialValueFor("damage_decrease")
		self.health_regen     = ability:GetSpecialValueFor("hp_regen")
		self:SetStackCount(self.health_regen)
	else
		self.health_regen = self:GetStackCount()
	end
end

function modifier_satan_overpain_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, -- GetModifierIncomingDamage_Percentage
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, -- GetModifierHealthRegenPercentage
	}
end

function modifier_satan_overpain_active:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self.damage_reduction
	end
end

function modifier_satan_overpain_active:GetModifierHealthRegenPercentage()
	return self.health_regen
end
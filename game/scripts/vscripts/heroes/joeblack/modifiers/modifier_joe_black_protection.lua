modifier_joe_black_protection = class({})

function modifier_joe_black_protection:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_status.vpcf"
end

function modifier_joe_black_protection:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_joe_black_protection:OnCreated(kv)
	self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.state = {}
end

function modifier_joe_black_protection:OnRefresh()
	if self:GetStackCount() > 0 then
		self.state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end
end

function modifier_joe_black_protection:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_joe_black_protection:GetModifierIncomingDamage_Percentage()
	return self.reduction
end

function modifier_joe_black_protection:CheckState()	
	return self.state
end
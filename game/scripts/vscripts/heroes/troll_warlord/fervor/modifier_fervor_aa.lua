modifier_fervor_aa = class({})

-----------------------------------------------------------------------------
function modifier_fervor_aa:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_fervor_aa:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_fervor_aa:OnCreated(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.target = nil
end

-------------------------------------------------------------------------------
function modifier_fervor_aa:OnRefresh(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

-------------------------------------------------------------------------------
function modifier_fervor_aa:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_fervor_aa:GetModifierProcAttack_Feedback(params)
	local parent = self:GetParent()
    if not parent or parent:PassivesDisabled() then return end
    if not IsServer() then return end
	
	if parent:IsIllusion() then return end

	parent:AddNewModifier(parent, self:GetAbility(), "modifier_fervor_aa_effect", { duration = self.duration })
	local stack_count = params.attacker:GetModifierStackCount("modifier_fervor_aa_effect", parent)
	
	if self.target == params.target then
		self:SetStacksCustom(stack_count + 1)
	else
		self:SetStacksCustom(1)
	end
	self.target = params.target
end

-------------------------------------------------------------------------------
function modifier_fervor_aa:SetStacksCustom(value)
    local attacker = self:GetParent()
    attacker:SetModifierStackCount("modifier_fervor_aa_effect", attacker, value)
end

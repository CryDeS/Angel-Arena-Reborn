modifier_boss_shield = class({})

function modifier_boss_shield:IsPurgable()
	return false
end

function modifier_boss_shield:OnCreated()
	local ability = self:GetAbility()

	self.damage_block 	  = ability:GetSpecialValueFor("damage_block")
	self.damage_threshold = ability:GetSpecialValueFor("damage_threshold")
	self.damage_recieved  = 0
end

function modifier_boss_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT, -- OnTakeDamageKillCredit
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}

	return funcs
end

function modifier_boss_shield:GetModifierPhysical_ConstantBlock()
	if not self.parent:PassivesDisabled() then
		return self.damage_block
	end 
end

function modifier_boss_shield:OnTakeDamageKillCredit(params)
	if not IsServer() then return end

	local parent = params.target

	if parent ~= self:GetParent() then return end

	if not parent or parent:IsNull() then return end

	if parent:PassivesDisabled() then return end

	if not parent:IsAlive() then return end

	self.damage_recieved = self.damage_recieved + params.damage
	self:SetStackCount(self.damage_recieved)

	if self.damage_recieved > self.damage_threshold then
		parent:Purge(false, true, false, true, true)
		self.damage_recieved = 0
		self:SetStackCount(self.damage_recieved) 
	end
end
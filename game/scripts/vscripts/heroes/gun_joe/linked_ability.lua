local _linked_toggle = _linked_toggle or {}

function _linked_toggle:ResetToggleOnRespawn()
	return false -- but dota will ignore this flag. cool?
end

function _linked_toggle:_Init()
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end

	self.linkedAbility = caster:FindAbilityByName(self.linkedAbilityName)

	assert(self.linkedAbility ~= nil)
end

function _linked_toggle:OnUpgrade()
	if not IsServer() then return end

	local level = self:GetLevel()

	if level == 1 then
		self:_Init()
	end

	local linked = self.linkedAbility

	if linked:GetLevel() ~= level then
		self.linkedAbility:SetLevel( level )
	end
end

function _linked_toggle:OnToggle()
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	local newState = self:GetToggleState()

	-- return our toggle stats if we now dead
	if not caster:IsAlive() and not newState then
		self:SetActivated(true)
		return
	end

	if not self:GetToggleState() then
		local mod = self.mod
		
		if mod then
			mod:Destroy()
			self.mod = nil
		end

		return 
	else
		local linked = self.linkedAbility

		if linked:GetToggleState() then
			linked:ToggleAbility()
		end

		local caster = self:GetCaster()

		self.mod = caster:AddNewModifier(caster, self, self.modifierName, { duration = -1 })
	end
end

function MakeLinkedBaseClass(abilityName, modifierName)
	local result = class({})
	
	for i, x in pairs(_linked_toggle) do
		result[i] = x
	end

	result.linkedAbilityName = abilityName
	result.modifierName = modifierName

	return result
end
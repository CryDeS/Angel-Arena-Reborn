modifier_keymaster_interception_effect = class({})
mod = modifier_keymaster_interception_effect

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true end

if IsServer() then
	function mod:OnCreated( kv )
		if not self or self:IsNull() then return end

		local parentMod = self:GetParentMod()

		if not parentMod then return end

		parentMod:IncrementStackCount()
	end

	function mod:OnDestroy( kv )
		if not self or self:IsNull() then return end

		local parentMod = self:GetParentMod()

		if parentMod then
			parentMod:DecrementStackCount()
		end
	end

	function mod:GetParentMod()
		local owner = self:GetAuraOwner()

		if not owner or owner:IsNull() then return end
		
		local parentMod = owner:FindModifierByNameAndCaster("modifier_keymaster_interception", owner)

		if not parentMod or parentMod:IsNull() then return end

		return parentMod
	end
end
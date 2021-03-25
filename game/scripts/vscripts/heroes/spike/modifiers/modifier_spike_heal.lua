local MakeHealModifier = function(isActive)
	local isPassive = not isActive

	local mod = class({})

	local falseFunc = function() return false end
	local trueFunc  = function() return true end

	if isActive then
		mod.IsHidden 		 = falseFunc
		mod.IsPurgable       = trueFunc
		mod.IsPurgeException = trueFunc
	else
		mod.IsHidden 		 = trueFunc
		mod.IsPurgable       = falseFunc
		mod.IsPurgeException = falseFunc
	end
	
	mod.DestroyOnExpire = trueFunc	
	mod.IsDebuff      	= falseFunc

	function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

	function mod:OnCreated(kv)
		local ability = self:GetAbility()

		local multiplier = 1

		if isActive then
			multiplier = ability:GetSpecialValueFor("multiplier") / 100
		end

		self.healPerSec   = ability:GetSpecialValueFor("heal_per_sec")  * multiplier
		self.statusResist = ability:GetSpecialValueFor("status_resist") * multiplier

		if isPassive then
			self.thresshold 	 = ability:GetSpecialValueFor("thresshold_pct") / 100
			self.passiveDuration = ability:GetSpecialValueFor("passive_duration")
			self.damageTaken 	 = 0
		else
			ability:OnCast()
		end
	end

	mod.OnRefresh = mod.OnCreated

	function mod:DeclareFunctions() 
		local res = { 
			MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		}

		if isPassive then
			table.insert(res, MODIFIER_EVENT_ON_TAKEDAMAGE)
		end

		return res
	end

	function mod:GetModifierStatusResistanceStacking() 
		if isPassive and self:GetParent():PassivesDisabled() then return 0 end

		return self.statusResist
	end

	function mod:GetModifierHealthRegenPercentage() 
		if isPassive and self:GetParent():PassivesDisabled() then return 0 end

		return self.healPerSec
	end

	if isPassive then
		function mod:OnTakeDamage(params)
			if not IsServer() 				then return end

			local parent = self:GetParent()

			if params.unit ~= parent 		then return end
			
			if not parent or parent:IsNull() then return end

			if parent:PassivesDisabled() 	then return end

			if not parent:IsAlive() 		then return end

			if not self.thresshold or self.thresshold == 0 then return end

			local newDamage = self.damageTaken + params.damage
			local abosrb = parent:GetMaxHealth() * self.thresshold

			local count = math.floor(newDamage / abosrb)

			if count ~= 0 then 
				newDamage = newDamage - count * abosrb

				local ability = self:GetAbility()

				local args = { duration = self.passiveDuration }

				for i = 1, count do
					parent:AddNewModifier(parent, ability, "modifier_spike_heal_active", args)
				end
			end

			self.damageTaken = newDamage
		end
	else
		mod.GetEffectAttachType = function()
			return PATTACH_OVERHEAD_FOLLOW
		end

		mod.GetEffectName = function()
			return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"
		end
	end

	return mod
end

modifier_spike_heal 		= modifier_spike_heal 		 or MakeHealModifier(false)
modifier_spike_heal_active  = modifier_spike_heal_active or MakeHealModifier(true)

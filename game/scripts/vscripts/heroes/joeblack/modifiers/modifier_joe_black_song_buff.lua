modifier_joe_black_song_buff = class({})

function modifier_joe_black_song_buff:OnCreated()
	local caster = self:GetCaster()
	if IsServer() then
		local talent = caster:FindAbilityByName("joe_black_special_song")
		self.regen = talent:GetSpecialValueFor("value")
		self:SetStackCount(self.regen)
		self:ForceRefresh()
	else
		self.regen = self:GetStackCount()
	end
end

function modifier_joe_black_song_buff:OnRefresh( ... )
	self.regen = self:GetStackCount()
end

function modifier_joe_black_song_buff:DeclareFunctions( ... )
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_joe_black_song_buff:GetModifierHealthRegenPercentage( ... )
	return self.regen
end
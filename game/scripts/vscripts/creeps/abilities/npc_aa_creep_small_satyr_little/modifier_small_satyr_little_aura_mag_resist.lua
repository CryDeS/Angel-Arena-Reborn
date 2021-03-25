modifier_small_satyr_little_aura_mag_resist = modifier_small_satyr_little_aura_mag_resist or class({})
local mod = modifier_small_satyr_little_aura_mag_resist

function mod:IsHidden() 			return false 	end
function mod:IsDebuff() 			return false 	end
function mod:IsPurgable() 			return false 	end
function mod:DestroyOnExpire() 		return true 	end

function mod:DeclareFunctions() return 
{ 
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end

function mod:GetModifierMagicalResistanceBonus() return self.mag_resist end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.mag_resist = ability:GetSpecialValueFor("mag_resist")
end

mod.OnRefresh = mod.OnCreated
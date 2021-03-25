modifier_small_satyr_little_aura_mag_resist_emitter = modifier_small_satyr_little_aura_mag_resist_emitter or class({})
local mod = modifier_small_satyr_little_aura_mag_resist_emitter

function mod:IsHidden() 			return true end
function mod:IsAura() 				return true end
function mod:IsPurgable() 			return false end
function mod:DestroyOnExpire() 		return false end

function mod:GetModifierAura() 		return "modifier_small_satyr_little_aura_mag_resist" end
function mod:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function mod:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function mod:GetAuraRadius() 		return self.radius or 0 end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.radius = ability:GetSpecialValueFor("radius")
end

mod.OnRefresh = mod.OnCreated
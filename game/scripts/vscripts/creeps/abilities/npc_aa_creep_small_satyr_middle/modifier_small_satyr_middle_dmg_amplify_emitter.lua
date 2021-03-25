modifier_small_satyr_middle_dmg_amplify_emitter = class({})

function modifier_small_satyr_middle_dmg_amplify_emitter:IsHidden() 		return true end
function modifier_small_satyr_middle_dmg_amplify_emitter:IsAura() 			return true end
function modifier_small_satyr_middle_dmg_amplify_emitter:IsPurgable() 		return false end
function modifier_small_satyr_middle_dmg_amplify_emitter:DestroyOnExpire() 	return false end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_dmg_amplify_emitter:GetModifierAura() 		return "modifier_small_satyr_middle_dmg_amplify" end
function modifier_small_satyr_middle_dmg_amplify_emitter:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_small_satyr_middle_dmg_amplify_emitter:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_small_satyr_middle_dmg_amplify_emitter:GetAuraRadius() 		return self.radius end

function modifier_small_satyr_middle_dmg_amplify_emitter:OnCreated( kv ) 
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
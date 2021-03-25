modifier_ability_artefact_altar = modifier_ability_artefact_altar or class({})
local mod = modifier_ability_artefact_altar

function mod:IsInvulnerable() return true end
function mod:IsStunned() return true end
function mod:IsHidden() return true end

function mod:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]  = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

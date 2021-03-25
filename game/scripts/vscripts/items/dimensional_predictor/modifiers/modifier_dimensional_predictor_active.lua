modifier_dimensional_predictor_active = class({})

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:GetTexture()
	return "../items/dimensional_predictor_big"
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:CheckState() return {
	[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
} end


--------------------------------------------------------------------------------

function modifier_dimensional_predictor_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_blur.vpcf"
end

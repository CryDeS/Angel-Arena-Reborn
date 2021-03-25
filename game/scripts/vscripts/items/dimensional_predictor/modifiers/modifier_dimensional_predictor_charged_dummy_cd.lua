modifier_dimensional_predictor_charged_dummy_cd = class({})
--------------------------------------------------------------------------------

function modifier_dimensional_predictor_charged_dummy_cd:IsHidden() 			return false; end
function modifier_dimensional_predictor_charged_dummy_cd:IsPurgable() 			return false; end
function modifier_dimensional_predictor_charged_dummy_cd:DestroyOnExpire() 		return false; end
function modifier_dimensional_predictor_charged_dummy_cd:IsDebuff() 			return false; end
function modifier_dimensional_predictor_charged_dummy_cd:RemoveOnDeath() 		return false; end

function modifier_dimensional_predictor_charged_dummy_cd:GetAttributes() 		return (MODIFIER_ATTRIBUTE_PERMANENT); end

function modifier_dimensional_predictor_charged_dummy_cd:GetTexture()
	return "../items/dimensional_predictor_big"
end
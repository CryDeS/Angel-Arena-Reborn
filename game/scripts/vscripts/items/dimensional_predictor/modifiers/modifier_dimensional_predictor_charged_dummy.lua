modifier_dimensional_predictor_charged_dummy = class({})
--------------------------------------------------------------------------------

function modifier_dimensional_predictor_charged_dummy:IsHidden() 			return false; end
function modifier_dimensional_predictor_charged_dummy:IsPurgable() 			return false; end
function modifier_dimensional_predictor_charged_dummy:DestroyOnExpire() 	return false; end
function modifier_dimensional_predictor_charged_dummy:RemoveOnDeath() 		return false; end

function modifier_dimensional_predictor_charged_dummy:GetAttributes() 		return (MODIFIER_ATTRIBUTE_PERMANENT); end

function modifier_dimensional_predictor_charged_dummy:GetTexture()
	return "../items/dimensional_predictor_charge_big"
end
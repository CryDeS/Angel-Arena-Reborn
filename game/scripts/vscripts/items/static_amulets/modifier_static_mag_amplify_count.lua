modifier_static_mag_amplify_count = class({})
--------------------------------------------------------------------------------

function modifier_static_mag_amplify_count:IsHidden() 			return false;  	end
function modifier_static_mag_amplify_count:IsDebuff() 			return false;   end 
function modifier_static_mag_amplify_count:IsPurgable() 		return true; 	end
function modifier_static_mag_amplify_count:DestroyOnExpire() 	return true; 	end

function modifier_static_mag_amplify_count:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT  end

--------------------------------------------------------------------------------

function modifier_static_mag_amplify_count:GetTexture()
	if not self:GetAbility() then return "" end 
    
    return "../items/" .. (self:GetAbility():GetAbilityTextureName() or "") .. "_big"
end

--------------------------------------------------------------------------------

function modifier_static_mag_amplify_count:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_timewalk.vpcf" end 

--------------------------------------------------------------------------------
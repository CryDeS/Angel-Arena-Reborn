modifier_static_disarm = class({})
--------------------------------------------------------------------------------

function modifier_static_disarm:IsHidden() 			return false;  	end
function modifier_static_disarm:IsDebuff() 			return true;   	end 
function modifier_static_disarm:IsPurgable() 		return false; 	end
function modifier_static_disarm:DestroyOnExpire() 	return true; 	end

--------------------------------------------------------------------------------

function modifier_static_disarm:GetTexture()
	if not self:GetAbility() then return "" end 
    
   	return "../items/" .. (self:GetAbility():GetAbilityTextureName() or "") .. "_big"
end

--------------------------------------------------------------------------------

function modifier_static_disarm:CheckState() return 
{
	[MODIFIER_STATE_DISARMED] = true,
}
end

--------------------------------------------------------------------------------

function modifier_static_disarm:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_debuff.vpcf" end 
function modifier_static_disarm:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end 

--------------------------------------------------------------------------------
modifier_static_mag_amplify = class({})

local count_name_mod        = "modifier_static_mag_amplify_count"

--------------------------------------------------------------------------------

function modifier_static_mag_amplify:IsHidden() 		return true;  	end
function modifier_static_mag_amplify:IsDebuff() 		return false;   end 
function modifier_static_mag_amplify:IsPurgable() 		return true; 	end
function modifier_static_mag_amplify:DestroyOnExpire() 	return true; 	end

function modifier_static_mag_amplify:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_static_mag_amplify:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

----------------------------------------------------------------------------

function modifier_static_mag_amplify:OnCreated()
	self.spellamp = self:GetAbility():GetSpecialValueFor("spell_amplify_by_cast")
end

function modifier_static_mag_amplify:OnDestroy()
	if not IsServer() then return end 

	local caster = self:GetParent() 

	local stack_count = caster:GetModifierStackCount(count_name_mod, caster) 
    caster:SetModifierStackCount(count_name_mod, caster, stack_count - 1)

    if (stack_count - 1) == 0 then
    	caster:RemoveModifierByName(count_name_mod)
    end 
end

--------------------------------------------------------------------------------

function modifier_static_mag_amplify:GetModifierSpellAmplify_Percentage(kv)        
	return self.spellamp
end
modifier_rebels_sword_disarmor = class({})
--------------------------------------------------------------------------------

function modifier_rebels_sword_disarmor:IsHidden() 			return false;  	end
function modifier_rebels_sword_disarmor:IsDebuff() 			return true;   	end 
function modifier_rebels_sword_disarmor:IsPurgable() 		return true; 	end
function modifier_rebels_sword_disarmor:DestroyOnExpire() 	return true; 	end

--------------------------------------------------------------------------------

function modifier_rebels_sword_disarmor:GetTexture()
	return "../items/rebels_sword_big"
end

--------------------------------------------------------------------------------

function modifier_rebels_sword_disarmor:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

--------------------------------------------------------------------------------

function modifier_rebels_sword_disarmor:GetModifierPhysicalArmorBonus(kv)        
	return -self:GetStackCount()    
end 
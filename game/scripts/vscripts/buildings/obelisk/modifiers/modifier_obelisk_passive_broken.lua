modifier_obelisk_passive_broken = class({})
--------------------------------------------------------------------------------

function modifier_obelisk_passive_broken:IsHidden() 		return true; 	end
function modifier_obelisk_passive_broken:IsPurgable() 		return false; 	end
function modifier_obelisk_passive_broken:DestroyOnExpire() 	return false; 	end

--------------------------------------------------------------------------------

function modifier_obelisk_passive_broken:DeclareFunctions()
	return { MODIFIER_PROPERTY_AVOID_DAMAGE }
end

-------------------------------------------------------------------------------

function modifier_obelisk_passive_broken:GetModifierAvoidDamage() return 1; end 

--------------------------------------------------------------------------------

function modifier_obelisk_passive_broken:CheckState() return 
{
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
}
end
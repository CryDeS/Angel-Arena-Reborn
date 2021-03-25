modifier_megacreep_energy_creature_buff = class({})
--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_buff:IsHidden() 	 	return false end
function modifier_megacreep_energy_creature_buff:RemoveOnDeath() 	return true end
function modifier_megacreep_energy_creature_buff:IsDebuff() 	 	return false end
function modifier_megacreep_energy_creature_buff:IsPurgable() 	 	return true end
function modifier_megacreep_energy_creature_buff:DestroyOnExpire()  return true end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_buff:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_buff:OnCreated( kv )
	self.resist = -kv.resist
end


function modifier_megacreep_energy_creature_buff:GetModifierIncomingDamage_Percentage()
	return self.resist
end

--------------------------------------------------------------------------------

function modifier_megacreep_energy_creature_buff:GetEffectName()
	return "particles/econ/items/razor/razor_apostle_tempest/razor_tempest_ambient.vpcf"
end

function modifier_megacreep_energy_creature_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

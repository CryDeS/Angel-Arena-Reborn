modifier_talisman_of_ambition_active = class({})

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:OnCreated( kv )
	self.evasion = kv.evasion
end
--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:GetModifierEvasion_Constant( params )
	return self.evasion 
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:OnDestroy()
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_blur.vpcf"
end

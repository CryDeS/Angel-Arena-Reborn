modifier_godmode = class({})

function modifier_godmode:IsHidden()
	return false
end

function modifier_godmode:IsPurgable()
	return false
end

function modifier_godmode:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,

	}
 
	return funcs
end

function modifier_godmode:CheckState()
	local state = {
		--[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVISIBLE]			= true,
	}
 
	return state
end

function modifier_godmode:GetModifierIncomingDamage_Percentage(params)
	return -100
end

function modifier_godmode:GetAbsoluteNoDamagePhysical(params)
	return 1
end

function modifier_godmode:GetAbsoluteNoDamageMagical(params)
	return 1
end

function modifier_godmode:GetAbsoluteNoDamagePure(params)
	return 1
end
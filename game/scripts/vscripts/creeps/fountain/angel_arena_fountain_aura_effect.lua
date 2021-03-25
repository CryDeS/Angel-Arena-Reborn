angel_arena_fountain_aura_effect = class({})

--------------------------------------------------------------------------------

function angel_arena_fountain_aura_effect:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function angel_arena_fountain_aura_effect:IsDebuff()
	return false
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function angel_arena_fountain_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function angel_arena_fountain_aura_effect:GetModifierIncomingDamage_Percentage( params )
	if self:GetAbility() then
		return -self:GetAbility():GetSpecialValueFor("resist_percent_fountain")
	end
	
	return 0
end

--------------------------------------------------------------------------------
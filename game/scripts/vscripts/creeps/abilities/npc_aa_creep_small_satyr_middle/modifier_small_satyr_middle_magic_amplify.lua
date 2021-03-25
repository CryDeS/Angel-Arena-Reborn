modifier_small_satyr_middle_magic_amplify = class({})

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :OnCreated( kv )
	self.percent = self:GetAbility():GetSpecialValueFor( "percent" )
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :OnRefresh( kv )
	self.percent = self:GetAbility():GetSpecialValueFor( "percent" )
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_small_satyr_middle_magic_amplify :GetModifierSpellAmplify_Percentage( params )
	return self.percent
end
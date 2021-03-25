modifier_megacreep_warrior_rage_lua = class({})

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:OnCreated( kv )
	self.bonus_resist_pct = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct" )
	if IsServer() then
		self:GetCaster():Purge(false, true, false, true, false)
	end
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:OnRefresh( kv )
	self.bonus_resist_pct = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct" )
end

--------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_megacreep_warrior_rage_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end
----------------------------------------------------------------------------------

function modifier_megacreep_warrior_rage_lua:GetModifierIncomingDamage_Percentage( )
	return -self.bonus_resist_pct
end

------------------------------------------------------------------------------

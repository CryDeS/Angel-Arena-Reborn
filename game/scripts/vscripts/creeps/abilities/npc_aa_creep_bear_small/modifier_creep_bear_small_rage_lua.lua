modifier_creep_bear_small_rage_lua = class({})

--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:GetStatusEffectName()
--    return "particles/status_fx/status_effect_avatar.vpcf"
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

--------------------------------------------------------------------------------
function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
    local mul = math.pow( 10, roundDig )
    return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end
--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:OnCreated( kv )
	self.bonus_attack_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_pct" )
	self.bonus_resist_pct = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct" )
	if IsServer() then
		self:GetCaster():Purge(false, true, false, true, false)
	end
    local bva = math_round(self:GetCaster():GetBaseAttackTime(),1);
	self.bonus_attack_speed = math.ceil (self:GetCaster():GetAttacksPerSecond() / 0.01 * self:GetCaster():GetBaseAttackTime() * self.bonus_attack_speed_pct / 100 )
    if math.abs (bva - 1.7) > 0.000001 then
          self.bonus_attack_speed = math.ceil (self.bonus_attack_speed / 100 * (1.7000000476837 * 100 / bva))
    end
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:OnRefresh( kv )
	self.bonus_attack_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed_pct" )
	self.bonus_resist_pct = self:GetAbility():GetSpecialValueFor( "bonus_resist_pct" )
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

----------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:GetModifierIncomingDamage_Percentage( )
	return -self.bonus_resist_pct
end

------------------------------------------------------------------------------

function modifier_creep_bear_small_rage_lua:GetModifierAttackSpeedBonus_Constant( )
	if self.bonus_attack_speed == nil then
		return 0
	end
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

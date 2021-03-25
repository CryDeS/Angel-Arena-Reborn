modifier_gnoll_small_one_slow = modifier_gnoll_small_one_slow or class({})

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:OnCreated(kv)
	self.attack_slow = self:GetAbility():GetSpecialValueFor("attack_slow")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink( 1 )
	end 
end 

--------------------------------------------------------------------------------

function modifier_gnoll_small_one_slow:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_corrosion_debuff.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
 
	return funcs
end

--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow 
end

--------------------------------------------------------------------------------
 
function modifier_gnoll_small_one_slow:OnIntervalThink()
	ApplyDamage(
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	})
end
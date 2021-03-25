modifier_spider_one_poison = modifier_spider_one_poison or class({})

--------------------------------------------------------------------------------

function modifier_spider_one_poison:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_one_poison:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_poison:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_poison:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_one_poison:OnCreated(kv)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")

	if IsServer() then
		self:StartIntervalThink( 1 )
	end 
end 

--------------------------------------------------------------------------------

function modifier_spider_one_poison:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_spider_one_poison:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_spider_one_poison:OnIntervalThink()
	ApplyDamage(
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	})
end
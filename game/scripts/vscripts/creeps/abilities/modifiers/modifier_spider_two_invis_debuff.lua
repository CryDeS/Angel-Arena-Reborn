modifier_spider_two_invis_debuff = class({})

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:OnCreated(kv)
	self.damage = self:GetAbility():GetSpecialValueFor("damage_per_sec")

	if IsServer() then
		self:StartIntervalThink( 1 )
		self:OnIntervalThink()
	end 
end 

--------------------------------------------------------------------------------

function modifier_spider_two_invis_debuff:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_spider_two_invis_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_spider_two_invis_debuff:OnIntervalThink()
	ApplyDamage(
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	})
end
modifier_spider_two_invis = class({})
--------------------------------------------------------------------------------

function modifier_spider_two_invis:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:OnCreated( kv )
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("poison_duration")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:OnAttackLanded( kv )
	local caster = self:GetParent()
	local ability = self:GetAbility() 

	if caster ~= kv.attacker then return end 

	local target = kv.target 

	target:AddNewModifier(caster, ability, "modifier_spider_two_invis_debuff", { duration = self.debuff_duration })

	ApplyDamage(
	{
		victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	})

	self:Destroy()
	caster:RemoveModifierByName("modifier_invisible")
end

--------------------------------------------------------------------------------

function modifier_spider_two_invis:DeclareFunctions()
	return 
	{ 
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
	}
end

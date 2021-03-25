modifier_ogre_small_burn = class({})

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:OnCreated(kv)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")

	if IsServer() then
		self:StartIntervalThink( 1 )
	end 
end 

--------------------------------------------------------------------------------

function modifier_ogre_small_burn:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ogre_small_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
 
function modifier_ogre_small_burn:OnIntervalThink()
	ApplyDamage(
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	})
end
modifier_ogre_small_buff = class({})
--------------------------------------------------------------------------------

function modifier_ogre_small_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:OnCreated( kv )
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("debuff_duration")
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:OnAttackLanded( kv )
	local caster = self:GetParent()
	local ability = self:GetAbility() 

	if caster ~= kv.target then return end 

	local attacker = kv.attacker 

	attacker:AddNewModifier(caster, ability, "modifier_ogre_small_buff_enemy", { duration = self.debuff_duration })
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:DeclareFunctions()
	return 
	{ 
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
	}
end

--------------------------------------------------------------------------------

function modifier_ogre_small_buff:GetEffectName()
	return "particles/neutral_fx/ogre_magi_frost_armor_model.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ogre_small_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
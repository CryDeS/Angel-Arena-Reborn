modifier_ogre_big_passive = class({})
--------------------------------------------------------------------------------

function modifier_ogre_big_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bash_duration = ability:GetSpecialValueFor("bash_duration")
	self.bash_damage = ability:GetSpecialValueFor("bash_damage")
	self.bash_chance = ability:GetSpecialValueFor("bash_chance")

	if not IsServer() then return end 
	
	self.dmg_type = self:GetAbility():GetAbilityDamageType()
end

modifier_ogre_big_passive.OnRefresh = modifier_ogre_big_passive.OnCreated

--------------------------------------------------------------------------------

function modifier_ogre_big_passive:OnAttackLanded( kv )
	if not IsServer() then return end 

	local caster = self:GetParent()
	local ability = self:GetAbility() 

	if caster ~= kv.attacker then return end 
	if not ability:IsCooldownReady() then return end 

	if RollPercentage(self.bash_chance) then 
		local target = kv.target 
		
		target:AddNewModifier(caster, ability, "modifier_ogre_big_passive_bash", {duration = self.bash_duration}) 

		ApplyDamage(
		{
		 	victim = target,
		 	attacker = caster,
		 	ability = ability, 
		 	damage = self.bash_damage,
		 	damage_type = self.dmg_type
		})

		ability:StartCooldown( ability:GetCooldown(ability:GetLevel()) )
	end 

end

--------------------------------------------------------------------------------

function modifier_ogre_big_passive:DeclareFunctions()
	return 
	{ 
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
	}
end
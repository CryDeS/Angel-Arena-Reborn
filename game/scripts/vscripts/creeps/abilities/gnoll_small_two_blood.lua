gnoll_small_two_blood = class({})
LinkLuaModifier( "modifier_gnoll_small_two_blood", 'creeps/abilities/modifiers/modifier_gnoll_small_two_blood', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gnoll_small_two_blood:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	local amp = self:GetSpecialValueFor("damage_amp") / 100

	if target:TriggerSpellAbsorb( self ) then return end  
		
	if target:HasModifier("modifier_gnoll_small_two_blood") then
		damage = damage + damage * amp
	end 

	ApplyDamage(
	{
		victim = target, 
		attacker = caster,
		ability = self, 
		damage = damage,
		damage_type = self:GetAbilityDamageType() 
	})

	target:AddNewModifier(caster, self, "modifier_gnoll_small_two_blood", {duration = self:GetSpecialValueFor("amp_duration")})
end
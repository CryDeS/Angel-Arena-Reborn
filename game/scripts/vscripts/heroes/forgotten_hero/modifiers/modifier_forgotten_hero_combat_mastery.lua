modifier_forgotten_hero_combat_mastery = modifier_forgotten_hero_combat_mastery or class({})

local mod = modifier_forgotten_hero_combat_mastery

function mod:IsHidden() 	 	return true end
function mod:RemoveOnDeath() 	return false  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return false end
function mod:IsPurgeException() return false  end
function mod:DestroyOnExpire()  return false  end

function mod:OnCreated( kv )
	if not IsServer() then return end 

	local ability = self:GetAbility()

	if not ability then return end

	self.disarmorDuration = ability:GetSpecialValueFor("disarmor_duration")
	self.damageDuration   = ability:GetSpecialValueFor("bonus_damage_duration")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:OnAttackLanded( kv )
	if not IsServer() then return end 

	local parent = self:GetParent()
	
	if parent ~= kv.attacker then return end 

	local ability = self:GetAbility()
	
	if not ability then return end

	local target = kv.target

	if not target then return end

	if target:IsBuilding() then return end
	
	if not parent:IsIllusion() then
		local mod = target:AddNewModifier(parent, ability, "modifier_forgotten_hero_combat_mastery_disarmor", { duration = self.disarmorDuration } )

		if mod then
			mod:IncrementStackCount()
		end
	end

	if target:IsHero() then
		local mod = parent:AddNewModifier(parent, ability, "modifier_forgotten_hero_combat_mastery_damage", { duration = self.damageDuration } )

		if mod then
			mod:IncrementStackCount()
		end
	end
end 
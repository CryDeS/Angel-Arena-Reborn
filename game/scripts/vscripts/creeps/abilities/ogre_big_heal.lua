ogre_big_heal = class({})
--------------------------------------------------------------------------------

function ogre_big_heal:OnSpellStart( keys )
	local target = self:GetCursorTarget() 
	local heal_const = self:GetSpecialValueFor("heal_const")
	local heal_per_min = self:GetSpecialValueFor("heal_per_min")

	local heal = heal_const + heal_per_min * ( GameRules:GetGameTime() / 60 )

	target:Heal(heal, self:GetCaster())

	local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target) 
	ParticleManager:SetParticleControl(fx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl(fx, 2, target:GetAbsOrigin() )
end
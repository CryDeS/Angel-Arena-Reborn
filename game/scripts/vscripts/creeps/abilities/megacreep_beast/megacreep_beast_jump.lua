megacreep_beast_jump = class({})

LinkLuaModifier("modifier_megacreep_beast_jump", "creeps/abilities/megacreep_beast/modifiers/modifier_megacreep_beast_jump", LUA_MODIFIER_MOTION_HORIZONTAL)

---------------------------------------------------------------------------

function megacreep_beast_jump:CreateEffects(caster, position)
end 

function megacreep_beast_jump:OnSpellStart()
	local caster = self:GetCaster() 
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget() 
	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_from_hp") * caster:GetHealth()
	local damage_type = self:GetAbilityDamageType() 

	caster:StartGesture(ACT_DOTA_NIAN_INTRO_LEAP)

	Timers:CreateTimer(0.4, function()
		caster:AddNewModifier(caster, self, "modifier_megacreep_beast_jump", { duration=duration, target=target:entindex(), damage=damage, damage_type=damage_type }) 
	end)
end

---------------------------------------------------------------------------
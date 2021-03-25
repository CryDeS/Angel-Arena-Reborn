megacreep_energy_creature_flash = class({})

LinkLuaModifier( "modifier_megacreep_energy_creature_flash", 'creeps/abilities/megacreep_energy_creature/modifiers/modifier_megacreep_energy_creature_flash', LUA_MODIFIER_MOTION_BOTH )

function megacreep_energy_creature_flash:IsHiddenWhenStolen() return false end

function megacreep_energy_creature_flash:OnSpellStart()
	local caster = self:GetCaster() 
	local pos	 = self:GetCursorPosition()
	local speed  = self:GetSpecialValueFor("speed")

	caster:AddNewModifier(caster, self, "modifier_megacreep_energy_creature_flash", { speed = speed, px = pos.x, py = pos.y, pz = pos.z })

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Winter_Wyvern.SplinterBlast.Cast", nil)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_beam.vpcf", PATTACH_WORLDORIGIN, parent)
	ParticleManager:SetParticleControlEnt( particle, 0, parent, PATTACH_WORLDORIGIN, "start_at_attachment", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt( particle, 2, parent, PATTACH_WORLDORIGIN, "start_at_attachment", pos, true)
end

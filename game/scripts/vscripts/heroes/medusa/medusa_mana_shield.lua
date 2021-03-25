medusa_mana_shield = class({})
LinkLuaModifier("modifier_medusa_mana_shield_2","heroes/medusa/modifier_medusa_mana_shield_2", LUA_MODIFIER_MOTION_NONE)

function medusa_mana_shield:ResetToggleOnRespawn()
	return true
end

function medusa_mana_shield:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_medusa_mana_shield_2", nil)
		local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_cast.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	else
		caster:RemoveModifierByName("modifier_medusa_mana_shield_2")
		caster:EmitSound("Hero_Medusa.ManaShield.Off")
		local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_end.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	end
end
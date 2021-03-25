small_satyr_little_invisible = class({})

function small_satyr_little_invisible:OnSpellStart() 
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_invisible", { duration = self:GetSpecialValueFor("duration") })
	local part = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(part, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
end
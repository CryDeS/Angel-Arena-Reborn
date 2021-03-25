huntress_hunting_spirit = huntress_hunting_spirit or class({})

LinkLuaModifier("modifier_huntress_hunting_spirit", "heroes/huntress/huntress_hunting_spirit/modifier_huntress_hunting_spirit", LUA_MODIFIER_MOTION_NONE)

function huntress_hunting_spirit:OnSpellStart()
	if not IsServer() then return end

	local caster 	= self:GetCaster()
	local duration 	= self:GetSpecialValueFor("duration")
	
	local startskill = ParticleManager:CreateParticle("particles/huntress/huntress_hunting_spirit/huntress_hunting_spirit_reincarnation.vpcf", PATTACH_POINT_FOLLOW, caster)
	
	ParticleManager:SetParticleControlEnt(startskill, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	caster:AddNewModifier(caster, self, "modifier_huntress_hunting_spirit", { duration = duration })

	caster:EmitSound("Hero_Huntress.HuntingSpirit")
end
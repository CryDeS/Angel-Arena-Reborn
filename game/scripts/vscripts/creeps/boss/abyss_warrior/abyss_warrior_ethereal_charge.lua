abyss_warrior_ethereal_charge = abyss_warrior_ethereal_charge or class({})

local ability = abyss_warrior_ethereal_charge

LinkLuaModifier( "modifier_abyss_warrior_ethereal_charge", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_ethereal_charge', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abyss_warrior_ethereal_charge_stun", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_ethereal_charge_stun', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()


	local duration = self:GetSpecialValueFor("active_duration")

	caster:AddNewModifier(caster, self, "modifier_abyss_warrior_ethereal_charge", { duration = duration })

	local casterPos = caster:GetAbsOrigin()

	local idx = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)

	ParticleManager:SetParticleControlEnt( idx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPos, true)

	caster:EmitSound("Hero_Warlock.FatalBonds")
end


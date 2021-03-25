spike_heal = class({})

ability = spike_heal

LinkLuaModifier( "modifier_spike_heal", "heroes/spike/modifiers/modifier_spike_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spike_heal_active", "heroes/spike/modifiers/modifier_spike_heal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ability:GetIntrinsicModifierName()
    return "modifier_spike_heal"
end

function ability:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("active_duration")

	caster:AddNewModifier(caster, self, "modifier_spike_heal_active", { duration = duration })

	self:OnCast()
end

function ability:OnCast()
	local parent = self:GetCaster()

	if IsServer() and parent then
		parent:EmitSound("Hero_Bloodseeker.BloodRite.Cast")
	end

	ParticleManager:CreateParticle("particles/world_shrine/dire_shrine_active_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
end
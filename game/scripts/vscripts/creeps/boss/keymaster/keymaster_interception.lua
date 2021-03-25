keymaster_interception = keymaster_interception or class({})

local ability = keymaster_interception

LinkLuaModifier( "modifier_keymaster_interception", 'creeps/boss/keymaster/modifiers/modifier_keymaster_interception', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_keymaster_interception_effect", 'creeps/boss/keymaster/modifiers/modifier_keymaster_interception_effect', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end
	
	local duration = self:GetSpecialValueFor("duration")

	caster:Purge( false, true, false, true, true )
	
	caster:AddNewModifier(caster, self, "modifier_keymaster_interception", { duration = duration })

	caster:EmitSound("Boss_Keymaster.Interception.Cast")

	ParticleManager:CreateParticle( "particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015_l_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
end


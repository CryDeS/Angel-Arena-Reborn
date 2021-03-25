keymaster_shadow_support = keymaster_shadow_support or class({})

local ability = keymaster_shadow_support

LinkLuaModifier( "modifier_keymaster_shadow_support", 'creeps/boss/keymaster/modifiers/modifier_keymaster_shadow_support', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end

	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_keymaster_shadow_support", { duration = duration })

	caster:EmitSound("Boss_Keymaster.ShadowSupport.Cast")
end


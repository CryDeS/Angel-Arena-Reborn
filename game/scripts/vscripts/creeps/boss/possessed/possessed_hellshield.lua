possessed_hellshield = possessed_hellshield or class({})

local ability = possessed_hellshield

LinkLuaModifier( "modifier_possessed_hellshield", 'creeps/boss/possessed/modifiers/modifier_possessed_hellshield', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_possessed_hellshield", { duration = duration })

	caster:EmitSound("Boss_Possessed.Hellshield.Cast")
end


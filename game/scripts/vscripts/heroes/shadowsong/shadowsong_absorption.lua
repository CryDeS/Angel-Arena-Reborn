shadowsong_absorption = class({})

local ability = shadowsong_absorption

LinkLuaModifier( "modifier_shadowsong_absorption_aura", 		"heroes/shadowsong/modifiers/modifier_shadowsong_absorption_aura", 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shadowsong_absorption_aura_effect", 	"heroes/shadowsong/modifiers/modifier_shadowsong_absorption_aura_effect", 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shadowsong_absorption_talent", 		"heroes/shadowsong/modifiers/modifier_shadowsong_absorption_talent", 		LUA_MODIFIER_MOTION_NONE )

function ability:IsHiddenWhenStolen() return false end

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster 	= self:GetCaster()
	local duration 	= self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_shadowsong_absorption_aura", { duration = duration })

	caster:EmitSound("Hero_Antimage.ManaVoidCast")
end
hola_grace = class({})
LinkLuaModifier("modifier_hola_grace", "heroes/hola/modifier_hola_grace", LUA_MODIFIER_MOTION_NONE)

function hola_grace:IsHiddenWhenStolen() 		return false end

function hola_grace:OnSpellStart( ... )
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(caster, self, "modifier_hola_grace", {duration = 2.5, heal = self:GetSpecialValueFor("heal")})
end


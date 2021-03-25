joe_black_protection = class({})
LinkLuaModifier("modifier_joe_black_protection", "heroes/joeblack/modifiers/modifier_joe_black_protection", LUA_MODIFIER_MOTION_NONE)

local talent_name = "joe_black_special_protection"

function joe_black_protection:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	local talent = caster:FindAbilityByName(talent_name)
	target:Purge( false, true, false, true, true )

	local mod = target:AddNewModifier(caster, self, "modifier_joe_black_protection", {duration = duration})
	if talent and talent:GetLevel() ~= 0 then 
		mod:SetStackCount(1)
		mod:ForceRefresh()
	end
	
	target:EmitSound("Hero_VengefulSpirit.WaveOfTerror")
end
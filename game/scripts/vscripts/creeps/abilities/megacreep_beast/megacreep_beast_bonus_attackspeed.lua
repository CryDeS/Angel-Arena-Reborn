megacreep_beast_bonus_attackspeed = class({})

LinkLuaModifier("modifier_megacreep_beast_bonus_attackspeed", "creeps/abilities/megacreep_beast/modifiers/modifier_megacreep_beast_bonus_attackspeed", LUA_MODIFIER_MOTION_NONE)

function megacreep_beast_bonus_attackspeed:OnSpellStart()
	local caster = self:GetCaster() 
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_megacreep_beast_bonus_attackspeed", { duration = duration })

	caster:EmitSound("Hero_LoneDruid.BattleCry.Bear")
end
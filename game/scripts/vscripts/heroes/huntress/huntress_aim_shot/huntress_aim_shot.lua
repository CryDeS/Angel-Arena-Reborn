huntress_aim_shot = huntress_aim_shot or class({})

LinkLuaModifier("modifier_huntress_aim_shot", "heroes/huntress/huntress_aim_shot/modifier_huntress_aim_shot", LUA_MODIFIER_MOTION_NONE)

function huntress_aim_shot:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()

	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_huntress_aim_shot", { duration = -1 })
		caster:EmitSound("Hero_Huntress.AimShot.Enable")
	else
		caster:RemoveModifierByName("modifier_huntress_aim_shot")
		caster:EmitSound("Hero_Huntress.AimShot.Disable")
	end
end

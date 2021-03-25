satan_might = class({})
LinkLuaModifier("modifier_satan_might_passive", "heroes/satan/satan_might/modifier_satan_might_passive", LUA_MODIFIER_MOTION_NONE)


function satan_might:GetIntrinsicModifierName()
	return "modifier_satan_might_passive"
end

function satan_might:OnUpgrade( )
	if IsServer() then
		local caster = self:GetCaster()
		local mod = caster:FindModifierByName("modifier_satan_might_passive")
		if mod then
			mod:ForceRefresh()
		end
	end
end
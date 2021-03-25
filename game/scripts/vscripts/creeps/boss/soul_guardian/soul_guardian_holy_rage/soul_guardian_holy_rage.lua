soul_guardian_holy_rage = class({})
local modifierRageBoost = "modifier_soul_guardian_holy_rage"
LinkLuaModifier(modifierRageBoost, "creeps/boss/soul_guardian/soul_guardian_holy_rage/"..modifierRageBoost, LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function soul_guardian_holy_rage:OnSpellStart()
	for _, var_name in pairs({ 
		"damage_for_purge_base", 
		"damage_for_purge_pct_from_max_hp",
		"max_duration",
	}) do
		self[var_name] = self:GetSpecialValueFor(var_name)
	end

	local caster = self:GetCaster()
	local buff = caster:AddNewModifier( caster, self, modifierRageBoost, { duration = self.max_duration } )
	buff:SetStackCount(caster:GetMaxHealth() / 100 * self.damage_for_purge_pct_from_max_hp + self.damage_for_purge_base)
end

--------------------------------------------------------------------------------

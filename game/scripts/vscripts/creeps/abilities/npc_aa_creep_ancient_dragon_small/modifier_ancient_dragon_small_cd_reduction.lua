modifier_ancient_dragon_small_cd_reduction = modifier_ancient_dragon_small_cd_reduction or class({})
local mod = modifier_ancient_dragon_small_cd_reduction

function mod:IsDebuff()
	return false
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	self.reduction = ability:GetSpecialValueFor("reduction")
end

mod.OnRefresh = mod.OnCreated

function mod:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

function mod:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function mod:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return funcs
end

--------------------------------------------------------------------------------

function mod:GetModifierCooldownReduction_Constant( params )
	return self.reduction
end

function mod:OnAbilityFullyCast( params )
	if params.ability ~= self:GetAbility() then
		local newCd = params.ability:GetCooldownTime() - self.reduction
		params.ability:EndCooldown()
		if newCd > 0 then 
			params.ability:StartCooldown(newCd)
		end
		self:Destroy()
	end
end
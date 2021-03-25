modifier_soul_guardian_holy_rage = modifier_soul_guardian_holy_rage or class({})
local mod = modifier_soul_guardian_holy_rage

function mod:IsHidden()         return false  end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:RemoveOnDeath()	return true end
mod.OnRefresh = mod.OnCreated

function mod:OnCreated()
	local ability = self:GetAbility()
	if not ability then return end
	self.status_resist_pct = ability:GetSpecialValueFor("status_resist_pct")
	self.attack_speed = ability:GetSpecialValueFor("attack_speed")
end

function mod:GetEffectName()
	return "particles/bosses/soul_guardian/soul_guardian_holy_rage/soul_guardian_holy_rage.vpcf"
end

function mod:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function mod:GetModifierStatusResistanceStacking()
	return self.status_resist_pct
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function mod:OnTooltip()
	return self:GetStackCount()
end

function mod:OnTakeDamage(params)
	local parent = params.unit

	if self:GetParent() ~= parent then return end 

	local currentStacks = self:GetStackCount()

	local newStacks = currentStacks - params.damage
	
	if newStacks > 0 then
		self:SetStackCount(newStacks)
	else
		self:Destroy()
	end
end

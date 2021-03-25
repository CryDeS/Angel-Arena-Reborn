modifier_amber_knife = modifier_amber_knife or class({})
local mod = modifier_amber_knife

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusHp 	 = ability:GetSpecialValueFor("bonus_health")
	self.bonusStats  = ability:GetSpecialValueFor("bonus_stats")
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy()
	if not IsServer() then return end

	local timer = self.timer

	if timer ~= nil then
		Timers:RemoveTimer(timer)
		self.timer = nil
	end
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:GetModifierHealthBonus()
	return self.bonusHp
end

function mod:GetModifierBonusStats_Strength( ... )
	return self.bonusStats
end

mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Agility   = mod.GetModifierBonusStats_Strength
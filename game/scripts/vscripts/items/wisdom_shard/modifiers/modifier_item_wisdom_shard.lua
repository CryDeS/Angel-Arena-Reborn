modifier_item_wisdom_shard = modifier_item_wisdom_shard or class({})
local mod = modifier_item_wisdom_shard

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()
	
	if not ability then return end

	self.bonusInt = ability:GetSpecialValueFor("bonus_int")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}
end

function mod:GetModifierBonusStats_Intellect()
	return self.bonusInt
end
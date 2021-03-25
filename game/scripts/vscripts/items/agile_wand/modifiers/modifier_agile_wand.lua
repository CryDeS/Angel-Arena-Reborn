modifier_agile_wand = modifier_agile_wand or class({})
local mod = modifier_agile_wand

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()
	
	if not ability then return end

	self.bonusAgi = ability:GetSpecialValueFor("bonus_agi")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
}
end

function mod:GetModifierBonusStats_Agility()
	return self.bonusAgi
end
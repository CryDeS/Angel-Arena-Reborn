modifier_health_gel = modifier_health_gel or class({})
local mod = modifier_health_gel

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()
	
	if not ability then return end

	self.hp = ability:GetSpecialValueFor("bonus_hp")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end

function mod:GetModifierHealthBonus()
	return self.hp
end
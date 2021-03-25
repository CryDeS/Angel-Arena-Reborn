modifier_shadowsong_absorption_talent = class({})
mod = modifier_shadowsong_absorption_talent

local talentName = "shadowsong_special_bonus_absorbtion_kill_bonus"

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end
function mod:GetAttributes()  	return MODIFIER_ATTRIBUTE_PERMANENT end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end

function mod:OnCreated( kv )
	self.hp = self:GetCaster():GetTalentSpecialValueFor(talentName)
end

mod.OnRefresh = mod.OnCreated

function mod:GetModifierHealthBonus() 
	return self.hp * self:GetStackCount()
end
modifier_amber_knife_invis = modifier_amber_knife_invis or class({})
local mod = modifier_amber_knife_invis

function mod:IsHidden()         return false  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusDamage   = ability:GetSpecialValueFor("invis_damage")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}
end

function mod:CheckState() return
{
	[MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end

function mod:GetModifierInvisibilityLevel()
	return 1
end

function mod:OnAbilityExecuted( params )
	if not IsServer() then return end

	if params.unit ~= self:GetParent() then return end

	local ability = params.ability

	if ability and ability:GetName() == "obsidian_destroyer_arcane_orb" then return end
	
	self:Destroy()
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierProcAttack_Feedback( params )
	if not self then return end
	if not IsServer() then return end

	self:Destroy()
end

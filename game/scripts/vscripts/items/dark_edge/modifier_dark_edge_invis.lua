modifier_dark_edge_invis = modifier_dark_edge_invis or class({})
local mod = modifier_dark_edge_invis

function mod:IsHidden()         return false  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:OnCreated()
	local ability = self:GetAbility()
	if not ability then return end

	self.movespeedBonus   = ability:GetSpecialValueFor("windwalk_movement_speed")
	self.backstabDuration = ability:GetSpecialValueFor("backstab_duration")
	self.bonusDamage   	  = ability:GetSpecialValueFor("windwalk_bonus_damage")
end

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}
end

function mod:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeedBonus
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

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:OnAbilityExecuted( params )
	if not IsServer() then return end

	if params.unit ~= self:GetParent() then return end

	local ability = params.ability

	if ability and ability:GetName() == "obsidian_destroyer_arcane_orb" then return end
	
	self:Destroy()
end

function mod:GetModifierProcAttack_Feedback( params )
	if not self then return end

	if not IsServer() then return end

	local target = params.target

	local ability = self:GetAbility()

	if ability and not ability:IsNull() and target and not target:IsNull() and target:IsAlive() and not target:IsMagicImmune() then
		target:AddNewModifier(params.attacker, ability, "modifier_dark_edge_debuff", { duration = self.backstabDuration })
	end

	self:Destroy()
end

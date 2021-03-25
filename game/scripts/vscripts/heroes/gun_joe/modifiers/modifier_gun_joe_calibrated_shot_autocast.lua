modifier_gun_joe_calibrated_shot_autocast = modifier_gun_joe_calibrated_shot_autocast or class({})
mod = modifier_gun_joe_calibrated_shot_autocast

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function mod:OnAttackStart( params )
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = params.target

	if not parent or parent:IsNull() then return end
	if not target or target:IsNull() then return end
	if not ability or ability:IsNull() or parent ~= params.attacker then return end

	if not target.IsHero then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	if not target:IsHero() and not target:IsCreature() and not target:IsBuilding() then return end

	if self:IsReady() then
		parent:CastAbilityOnTarget( target, ability, parent:GetPlayerOwnerID() )
	end
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.attackRange = ability:GetSpecialValueFor( "bonus_attack_range" )
end

mod.OnRefresh = mod.OnCreated

function mod:IsReady()
	if not self or self:IsNull() then return false end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return false end

	if not ability:GetAutoCastState() then return false end

	if ability:GetCooldownTimeRemaining() ~= 0 then return false end

	local parent = self:GetParent()

	if not parent then return false end

	local target = parent:GetAttackTarget()

	if not target or target:IsNull() then return false end

	if not target.IsHero then return true end

	return ability:CastFilterResultTarget(target) == UF_SUCCESS
end

function mod:GetModifierAttackRangeBonus( kv )
	if IsServer() and self:IsReady() then
		return self.attackRange
	end

	-- Fuck client, it dont even have GetAutoCastState
	return 0
end

modifier_possessed_rebel = modifier_possessed_rebel or class({})
local mod = modifier_possessed_rebel

function mod:IsDebuff() 		return false end
function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.debuffDuration = ability:GetSpecialValueFor("disarmor_duration")
	self.statusResist   = ability:GetSpecialValueFor("status_resist_per_hp")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:GetModifierStatusResistance()
	local resist = self.statusResist
	local parent = self:GetParent()

	if not parent then return 0 end

	return resist * (100 - parent:GetHealthPercent())
end

function mod:OnAttackLanded( params )
	if not IsServer() then return end

	if not self then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = params.target

	if not ability or parent ~= params.attacker then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	local duration = self.debuffDuration

	if not duration then return end

	local mod = target:AddNewModifier(parent, ability, "modifier_possessed_rebel_debuff", { duration = duration })

	if mod then
		mod:IncrementStackCount()
	end
end

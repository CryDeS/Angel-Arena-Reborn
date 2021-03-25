modifier_devour_helm_dominated = modifier_devour_helm_dominated or class({})
local mod = modifier_devour_helm_dominated

function mod:IsHidden()         return false  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetTexture()
	return "../items/devour_helm_big"
end

function mod:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function mod:CheckState() return
{
	[MODIFIER_STATE_DOMINATED] = true,
}
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
}
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()
	local parent = self:GetParent()
	
	if not ability then return end
	if not parent then return end

	self.moveSpeed 	= ability:GetSpecialValueFor("speed_base")

	if IsServer() then
		local baseHp = ability:GetSpecialValueFor("health_min")
		local currentBaseHp = parent:GetBaseMaxHealth()

		if baseHp > currentBaseHp then
			parent:SetBaseMaxHealth( baseHp )
		end
	end
end

mod.OnRefresh = mod.OnCreated

function mod:GetModifierMoveSpeedOverride()
	return self.moveSpeed or 0
end

function mod:OnDestroy()
	if not IsServer() then return end

	local ability = self:GetAbility()

	if not ability then return end

	ability:ReleashDominatedCreep()
end
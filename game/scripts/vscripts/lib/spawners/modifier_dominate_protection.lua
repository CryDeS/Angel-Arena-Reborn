modifier_dominate_protection = modifier_dominate_protection or class({})
local mod = modifier_dominate_protection

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_DOMINATED,
	MODIFIER_EVENT_ON_DEATH,
}
end

function mod:OnDominated(params)
	if not IsServer() then return end

	local unit = params.unit
	local parent = self:GetParent()

	if unit ~= parent then return end

	CreepSpawner:_OnDominated( unit )

	self:Destroy()
end

function mod:OnDeath(kv)
	if not IsServer() then return end

	local parent = self:GetParent()

	local unit = kv.unit

	if unit ~= parent then return end

	CreepSpawner:_OnDied( unit )
end
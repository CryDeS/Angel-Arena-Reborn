modifier_boss_soul = modifier_boss_soul or class({})
local mod = modifier_boss_soul

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated( kv )
	if not IsServer() then return end

	local parent = self:GetParent()

	if not parent then return end	

	local ability = self:GetAbility()

	if not ability then return end

	ability:SetPurchaser( parent )
end

mod.OnRefresh = mod.OnCreated
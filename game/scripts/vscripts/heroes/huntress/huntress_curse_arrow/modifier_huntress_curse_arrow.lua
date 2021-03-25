modifier_huntress_curse_arrow = modifier_huntress_curse_arrow or class({})
local mod = modifier_huntress_curse_arrow

function mod:IsHidden() return false end
function mod:IsDebuff() return true end
function mod:IsPurgable() return false end
function mod:IsPurgeException() return false end
mod.OnRefresh = mod.OnCreated

function mod:GetStatusEffectName(kv)
    return "particles/huntress/huntress_hunting_spirit/huntress_hunting_spirit.vpcf"
end

function mod:OnCreated()
	self:StartIntervalThink(0.1)
end

function mod:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	parent:Purge(true, false, false, false, true)
end 

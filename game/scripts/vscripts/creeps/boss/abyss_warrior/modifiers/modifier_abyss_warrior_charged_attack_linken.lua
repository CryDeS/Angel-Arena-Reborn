modifier_abyss_warrior_charged_attack_linken = modifier_abyss_warrior_charged_attack_stun or class({})
local mod = modifier_abyss_warrior_charged_attack_linken

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return false end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function mod:GetEffectName()
	return "particles/items_fx/immunity_sphere_buff.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function mod:GetAbsorbSpell(keys)
	local stackCount = self:GetStackCount() - 1

	if stackCount == 0 then
		Timers:CreateTimer(0.001, function()
			self:Destroy()
		end)
	end

	local parent = self:GetParent()

	parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
	ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_POINT_FOLLOW, parent)

	self:SetStackCount( stackCount )

	return 1
end

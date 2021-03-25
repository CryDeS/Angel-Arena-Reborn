modifier_heavy_crossbow_crit = modifier_heavy_crossbow_crit or class({})
local mod = modifier_heavy_crossbow_crit

function mod:IsHidden()         return true  end
function mod:IsDebuff()         return false end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.crit = ability:GetSpecialValueFor("crit_damage")
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}
end

function mod:GetModifierPreAttack_CriticalStrike()
	return self.crit
end

function mod:GetModifierProcAttack_Feedback( params )
	local target = params.target

	if not target then return end
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
	ParticleManager:SetParticleControl(particle, 2, target:GetOrigin())
	ParticleManager:SetParticleControl(particle, 3, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	target:EmitSound("Item_HeavyCrossbow.Crit")
end

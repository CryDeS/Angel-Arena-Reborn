modifier_soul_guardian_heavy_strike = modifier_soul_guardian_heavy_strike or class({})
local mod = modifier_soul_guardian_heavy_strike

function mod:IsHidden()         return true  end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
mod.OnRefresh = mod.OnCreated

function mod:OnCreated()
	local ability = self:GetAbility()
	if not ability then return end
    self.duration_slow = ability:GetSpecialValueFor("duration_slow")
    self.duration_stun = ability:GetSpecialValueFor("duration_stun")
end

function mod:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, }
end

function mod:OnAttackLanded(params)
    if not IsServer() then return end
    local caster = self:GetParent()
    if params.attacker ~= caster or caster:PassivesDisabled() then return end
	local ability = self:GetAbility()
	if ability:GetCooldownTimeRemaining() > 0 then return end
	
	ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1) * caster:GetCooldownReduction())
	
	local particle = ParticleManager:CreateParticle("particles/bosses/soul_guardian/soul_guardian_heavy_strike/econ/items/ursa/ursa_ti10/soul_guardian_heavy_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
	ParticleManager:SetParticleControlEnt(particle, 0, params.target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, Vector(320, 155, 130) )
	ParticleManager:ReleaseParticleIndex(particle)
	
    params.target:AddNewModifier(caster, ability, "modifier_soul_guardian_heavy_strike_stun", { duration = self.duration_stun })
	
	local allies = FindUnitsInRadius(
		params.target:GetTeamNumber(), 
		params.target:GetOrigin(), 
		params.target,
		ability:GetSpecialValueFor("knockback_radius_search"), 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false 
	)
	local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
	local point = params.target:GetAbsOrigin()
	
	for _, unit in pairs(allies) do
		if unit ~= params.target then
			unit:AddNewModifier(caster, ability, "modifier_soul_guardian_heavy_strike_knockback", {
				radius = ability:GetSpecialValueFor("knockback_radius"),
				duration = knockback_duration,
				dur = knockback_duration,
				point = Vector(point.x, point.y, point.z),
			})
			unit:AddNewModifier(caster, ability, "modifier_soul_guardian_heavy_strike_slow", { duration = self.duration_slow })
		end
	end
end

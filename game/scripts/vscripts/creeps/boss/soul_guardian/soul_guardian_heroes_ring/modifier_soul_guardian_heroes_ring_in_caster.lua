modifier_soul_guardian_heroes_ring_in_caster = modifier_soul_guardian_heroes_ring_in_caster or class({})
local mod = modifier_soul_guardian_heroes_ring_in_caster

function mod:IsHidden()         return true  end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:RemoveOnDeath()	return true end

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function mod:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end
function mod:OnDestroy()
	if not IsServer() then return end
	
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	
	if ability.particleFirstCircle then
		ParticleManager:DestroyParticle(ability.particleFirstCircle, false)
	end
	if ability.particleSecondCircle then
		ParticleManager:DestroyParticle(ability.particleSecondCircle, false)
	end
end

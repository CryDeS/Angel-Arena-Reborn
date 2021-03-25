modifier_megacreep_energy_creature_passive = class({})
mod = modifier_megacreep_energy_creature_passive

function mod:IsHidden()        return false end
function mod:DestroyOnExpire() return true end
function mod:IsPurgable()      return false end
function mod:IsDebuff()        return false end

--------------------------------------------------------------------------------

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	self.attackCount = ability:GetSpecialValueFor("attack_count")
	self._nAttack = 0
end

function mod:OnRefresh( kv )
	self:OnCreated(kv)
end

function mod:DeclareFunctions() return
{
	MODIFIER_EVENT_ON_ATTACKED,
}
end

function mod:OnAttacked( params )
	local caster = self:GetParent()

	if caster ~= params.attacker then return end
	if not IsServer() then return end
	if caster:PassivesDisabled() then return end 

	self._nAttack = self._nAttack + 1

	if self._nAttack > self.attackCount then
		self._nAttack = 0

		local target = params.target
		local ability = self:GetAbility()

		local damage = caster:GetAverageTrueAttackDamage( nil )

		ApplyDamage({
			victim		= target, 
			attacker	= caster,
			damage		= damage, 
			damage_type = ability:GetAbilityDamageType(), 
			ability		= ability,
		})

		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/phase_boots_ti7_splash.vpcf",  PATTACH_POINT_FOLLOW, target)

		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Razor.UnstableCurrent.Target", caster)
	end
end
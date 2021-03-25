modifier_centaur_return_custom_aura = class({})

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:OnCreated( kv )

end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_centaur_return_custom_aura:OnAttacked( params )
	if self:GetParent() ~= params.target then
		return
	end

	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster() 

		if not caster then caster = params.target; end 

		if caster:PassivesDisabled() then return end 

		local damage = ( ability:GetSpecialValueFor("return_damage") or 0 ) + caster:GetStrength() * ( ability:GetSpecialValueFor("strength_pct") or 0 ) / 100

		ApplyDamage({
			victim = params.attacker, 
			attacker = params.target,
			damage = damage, 
			damage_type = DAMAGE_TYPE_PURE, 
			ability = self:GetAbility(), 
		})
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf",  PATTACH_POINT_FOLLOW, params.target)

	ParticleManager:SetParticleControlEnt(particle, 1, params.attacker,  PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), false)

	return 0
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
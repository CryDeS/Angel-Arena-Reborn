modifier_megacreep_ancient_golem_fire_fist = class({})

function modifier_megacreep_ancient_golem_fire_fist:IsPurgable()
	return false
end

function modifier_megacreep_ancient_golem_fire_fist:IsHidden()
	return true
end

function modifier_megacreep_ancient_golem_fire_fist:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_megacreep_ancient_golem_fire_fist:OnCreated()
	if not IsServer() then return end
	
	local ability = self:GetAbility()

	if not ability then return end

	self.hit_damage = ability:GetSpecialValueFor("hit_damage")
end

function modifier_megacreep_ancient_golem_fire_fist:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or not IsServer() then return end
	local damage = {
		victim = params.target,
		attacker = self:GetParent(),
		damage = self.hit_damage or 0,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}
	ApplyDamage(damage)
end
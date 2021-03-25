modifier_megacreep_ancient_golem_burn_close = class({})

function modifier_megacreep_ancient_golem_burn_close:IsPurgable()
	return true
end

function DamagePerTimerate(caster, parent, dmgToDeal, tickrate, Ability)
	if not IsServer() then return end
	Timers:CreateTimer("ancient_golem_burn_close" .. tostring(parent:entindex()), {
		--useGameTime = false,
		--endTime = 1,
		callback = function()
			local damage = {
				victim = parent,
				attacker = caster,
				damage = dmgToDeal,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = Ability,
			}
			ApplyDamage(damage)
			local part = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControlEnt(part, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			if not parent:IsAlive() then return nil end
			return tickrate
		end
	})
end

function modifier_megacreep_ancient_golem_burn_close:OnCreated()
	if not IsServer() then return end
	self.tickrate = self:GetAbility():GetSpecialValueFor("tickrate")
	self.DmgPerTick = self:GetAbility():GetSpecialValueFor( "TotalDmg" ) / (self:GetDuration() / self.tickrate)
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	DamagePerTimerate(caster, parent, self.DmgPerTick, self.tickrate, ability)
end

function modifier_megacreep_ancient_golem_burn_close:OnDestroy(params)
	if not IsServer() then return end
	Timers:RemoveTimer("ancient_golem_burn_close" .. tostring(self:GetParent():entindex()))
end
modifier_satan_might_passive = class({})

function modifier_satan_might_passive:IsHidden( ... )
	return true
end

function modifier_satan_might_passive:IsPurgable( ... )
	return false
end


function modifier_satan_might_passive:OnCreated()
	if not IsServer() then return end
	local ability   	= self:GetAbility()
	self.talent 		= self:GetParent():FindAbilityByName("satan_special_bonus_might_nocd")
	self.chance			= ability:GetSpecialValueFor("chance")
	self.radius 		= ability:GetSpecialValueFor("radius")
	self.stun_duration  = ability:GetSpecialValueFor("stun_duration") 
end

function modifier_satan_might_passive:OnRefresh()
	if not IsServer() then return end
	local ability   	= self:GetAbility()
	self.chance			= ability:GetSpecialValueFor("chance")
	self.radius 		= ability:GetSpecialValueFor("radius")
	self.stun_duration  = ability:GetSpecialValueFor("stun_duration") 
end

function modifier_satan_might_passive:DeclareFunctions()
	funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED, -- OnAttackLanded
	}
	return funcs
end

function modifier_satan_might_passive:OnAttackLanded( params )
	if not IsServer() then return end

	local target = params.target
	local attacker = params.attacker

	if target ~= self:GetParent() then return end

	if target:GetTeamNumber() == attacker:GetTeamNumber() then return end

	if target:PassivesDisabled() then return end

	if attacker:IsMagicImmune() then return end
	
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then return end

	if (attacker:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > self.radius then return end

	if RollPercentage(self.chance) then
		attacker:AddNewModifier(target, self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})

		attacker:EmitSound("DOTA_Item.SkullBasher")
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(particle, 0, attacker:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		-- add particle effect
		-- 

		if self.talent:GetLevel() == 0 then
			self:GetAbility():UseResources(false, false, true)
		end
	end
end
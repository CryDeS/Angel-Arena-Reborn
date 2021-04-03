item_devour_helm = item_devour_helm or class({})
local ability = item_devour_helm

LinkLuaModifier( "modifier_devour_helm", 				'items/devour_helm/modifiers/modifier_devour_helm', 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devour_helm_aura", 			'items/devour_helm/modifiers/modifier_devour_helm_aura', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devour_helm_active", 		'items/devour_helm/modifiers/modifier_devour_helm_active', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devour_helm_active_stun",	'items/devour_helm/modifiers/modifier_devour_helm_active_stun', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devour_helm_dominated", 		'items/devour_helm/modifiers/modifier_devour_helm_dominated', 	LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_devour_helm"
end

function ability:GetAbilityTextureName()
	if self.target then
		return"devour_helm_active"
	else 
		return "devour_helm"
	end
end

function ability:GetCastFilter(hTarget)
	if not self then return end

	local caster = self:GetCaster()

	if not caster then return end
	if not hTarget then return end

	if caster == hTarget then
		return UF_FAIL_CUSTOM, "#dota_hud_error_cant_cast_on_self"
	end

	if caster:GetTeamNumber() ~= hTarget:GetTeamNumber() then
		if (hTarget:IsHero() or hTarget:IsConsideredHero()) then
			return UF_FAIL_CUSTOM, "#dota_hud_error_cant_cast_enemy_hero"
		end
	else
		if not hTarget:IsCreep() and not hTarget:IsHero() and not hTarget:IsConsideredHero() or hTarget:IsAncient() then
			return UF_FAIL_CUSTOM, "#dota_hud_error_cast_only_hero_and_creeps"
		end

		if IsServer() then
			if PlayerResource:IsDisableHelpSetForPlayerID( caster:GetPlayerOwnerID(), hTarget:GetPlayerOwnerID() ) then
				return UF_FAIL_DISABLE_HELP, "#dota_hud_error_target_has_disable_help"
			end
		end
	end
	
	return UF_SUCCESS, ""
end

function ability:CastFilterResultTarget( hTarget )
	local errCode, errText = self:GetCastFilter(hTarget)

	return errCode or UF_SUCCESS
end

function ability:GetCustomCastErrorTarget( hTarget )
	local errCode, errText = self:GetCastFilter(hTarget)

	return errText or ""
end

function ability:GetBehavior()
	if self.target then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
	end
end

function ability:Dominate(caster, target)
	if not IsServer() then return end

	if target:IsConsideredHero() then return end 

	local dominatedCreep = self.dominatedCreep
	
	if dominatedCreep and not dominatedCreep:IsNull() and IsValidEntity(dominatedCreep)then
		dominatedCreep:Kill(self, caster)
	end

	self.dominatedCreep = target

	target:RemoveModifierByName("modifier_chen_holy_persuasion")
	target:AddNewModifier(caster, self, "modifier_devour_helm_dominated", { duration = -1 })
	target:AddNewModifier(caster, self, "modifier_item_phase_boots_active", { duration = 0.3 })

	target:SetTeam( caster:GetTeamNumber() )
	target:SetOwner( caster )
	target:SetControllableByPlayer( caster:GetPlayerOwnerID() , true )
	target:SetHealth( target:GetMaxHealth() )
	target:SetMana( target:GetMaxMana() )

	target:Stop()
	target:Hold()

	--self:StartCooldown( self:GetCooldownTime() * caster:GetCooldownReduction() )
end

function ability:TakeUnitIntoPocket(caster, target)
	if IsServer() then
		self:EndCooldown()

		target:Stop()
		target:Hold()

		local particleSoulBind = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf", PATTACH_POINT_FOLLOW, caster)

		-- why 5 here
		for i = 0, 5 do
			ParticleManager:SetParticleControlEnt(particleSoulBind, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(particleSoulBind, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		end

		target:AddNewModifier(caster, self, "modifier_devour_helm_active_stun", { duration = 1 })

		self.targetMod = target:AddNewModifier(caster, self, "modifier_devour_helm_active", { duration = -1 })
	end
end

function ability:SetPocketUnit(unit)
	self.target = unit
end

function ability:ReleashPocketUnit()
	if IsServer() then
		local mod = self.targetMod

		if mod and not mod:IsNull() then
			mod:Destroy()
		end

		self.targetMod = nil
	end

	self.target = nil
end

function ability:ReleashDominatedCreep()
	self.dominatedCreep = nil
end

function ability:OnSpellStart()
	local caster = self:GetCaster() 
	local target = self:GetCursorTarget()

	if caster:IsCourier() then return end
	if target and target:IsBuilding() then return end

	if self.target == nil then
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			self:Dominate( caster, target )
		else
			self:TakeUnitIntoPocket( caster, target )
		end
	else
		self:ReleashPocketUnit()
	end
end

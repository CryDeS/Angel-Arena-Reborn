modifier_keymaster_damned_souls = modifier_keymaster_damned_souls or class({})
local mod = modifier_keymaster_damned_souls

function mod:IsHidden() 			return false end
function mod:IsPurgable() 			return false end
function mod:DestroyOnExpire() 		return true end
function mod:IsPurgeException() 	return false end
function mod:GetEffectName() 		return "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf" end
function mod:GetEffectAttachType() 	return PATTACH_ABSORIGIN_FOLLOW end

if not IsServer() then return end

function mod:ReleaseProjectiles()
	if self.timer ~= nil then
		Timers:RemoveTimer(self.timer)
		self.timer = nil
	end

	-- Crydes: Deleting projectile cause dota crash(but when projectile is still flying - there is no crash. i dont know wtf that)
	for proj, _ in pairs(self.projs) do
		--ProjectileManager:DestroyTrackingProjectile(proj)
	end

	self.projs = {}
end

function mod:OnDestroy()
	self:ReleaseProjectiles()

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	if parent:IsAlive() then
		parent:EmitSound( "Boss_Keymaster.DamnedSouls.DestroyEffect")
		ParticleManager:CreateParticle( "particles/econ/items/outworld_devourer/od_ti8/od_ti8_santies_eclipse_area_beams.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	end
end

function mod:OnCreated(kv)
	if not self or self:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	local parent 	  = self:GetParent()

	self.tickCount 	  = ability:GetSpecialValueFor("soul_count")
	self.tickInterval = ability:GetSpecialValueFor("interval")
	self.projSpeed 	  = ability:GetSpecialValueFor("projectile_speed")
	self.radius 	  = ability:GetCastRange(parent:GetAbsOrigin(), nil) + parent:GetCastRangeBonus()

	self.debuffTime   = ability:GetSpecialValueFor("debuff_duration")
	self.damageType   = ability:GetAbilityDamageType()
	self.damage 	  = ability:GetSpecialValueFor("damage")
	self.damageFromHp = ability:GetSpecialValueFor("damage_from_lost_hp") / 100

	self.projs = self.projs or {}
	self.timer = Timers:CreateTimer( self.tickInterval, function() return self:OnTick() end)
	self.nProjs = 0

	self:SetStackCount(self.tickCount)
end

function mod:Launch(caster, target, speed, ability)
	local projInfo = {
		EffectName 	= "particles/bosses/keymaster/damned_souls/damned_soul.vpcf",
		Ability 	= ability,
		iMoveSpeed 	= speed,
		Source 		= caster,
		Target 		= target,
		bDodgeable  = true,
	}

	local proj = ProjectileManager:CreateTrackingProjectile( projInfo )

	self.projs[proj] = true
	self.nProjs = self.nProjs + 1

	caster:EmitSound("Boss_Keymaster.DamnedSouls.Launch")

	local idx = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_initial_explode_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( idx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
end

function mod:OnTick()
	if not self or self:IsNull() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	local target

	local enemies = FindUnitsInRadius( 	parent:GetTeamNumber(),
										parent:GetAbsOrigin(),
										nil, 
										self.radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
										FIND_CLOSEST, 
										false )


	for _, enemy in pairs(enemies) do
		if enemy and IsValidEntity(enemy) then
			target = enemy
			break
		end
	end

	if target and not target:IsNull() then
		self:Launch( parent, target, self.projSpeed, self:GetAbility() )

		self.tickCount = self.tickCount - 1
		
		self:SetStackCount(self.tickCount)

		if self.tickCount <= 0 then
			return nil
		end
	end

	return self.tickInterval
end

function mod:SubHit(hTarget)
	self.nProjs = self.nProjs - 1

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	if hTarget and not hTarget:IsNull() then
		hTarget:AddNewModifier(parent, ability, "modifier_keymaster_damned_souls_debuff", { duration = self.debuffTime })

		local damage = self.damage + (hTarget:GetMaxHealth() - hTarget:GetHealth()) * self.damageFromHp

		local damageTable = {
			victim 	 	= hTarget,
			attacker 	= parent,
			damage 		= damage,
			damage_type = self.damageType,
			ability 	= self
		}

		ApplyDamage( damageTable )
	end

	parent:EmitSound("Boss_Keymaster.DamnedSouls.Hit")

	ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
end

function mod:OnHit(hTarget)
	if not self or self:IsNull() then return end

	self.nProjs = self.nProjs - 1

	self:SubHit( hTarget )

	if self.nProjs <= 0 and self.tickCount <= 0 then
		Timers:CreateTimer(0, function()
			if self and not self:IsNull() then
				self:Destroy()
			end
		end)
	end
end
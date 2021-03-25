joe_black_face_of_death = class({})

local talent_name_1 = "joe_black_special_unique_cooldown"
local talent_name_2 = "joe_black_special_unique_aoe"
local talent_name_3 = "joe_black_special_target_ult"

function joe_black_face_of_death:GetAOERadius()
	local radius = 0

	local net_table = CustomNetTables:GetTableValue( "heroes", "joe_black_face_of_death_talent_2" )

	if(net_table) then
		radius = net_table.radius
	end

	return radius
end

function joe_black_face_of_death:GetCooldown( nLevel )
	local nettable = CustomNetTables:GetTableValue( "heroes", "joe_black_face_of_death" )

	if nettable and nettable.cooldown > 0 then
		return nettable.cooldown
	end

	return self.BaseClass.GetCooldown(self, nLevel) 
end


function joe_black_face_of_death:OnAbilityPhaseStart()
	local caster 		  = self:GetCaster()
	local base_radius 	  = self:GetSpecialValueFor("radius")

	local talent_radius   = caster:FindAbilityByName(talent_name_2)
	local talent_cooldown = caster:FindAbilityByName(talent_name_1)

	if talent_cooldown then
		self.cooldown = talent_cooldown:GetSpecialValueFor("value")
	else
		self.cooldown = self:GetCooldown(self:GetLevel())
	end

	if talent_radius then
		self.radius = base_radius + talent_radius:GetSpecialValueFor("value")
	else
		self.radius = base_radius
	end

	CustomNetTables:SetTableValue( "heroes", "joe_black_face_of_death", { cooldown = self.cooldown, radius = self.radius } )

	return true
end

function joe_black_face_of_death:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	if not IsServer() then return end

	if self.radius > 0 then
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			target:GetAbsOrigin(), 
			caster, 
			self.radius, 
			DOTA_UNIT_TARGET_TEAM_BOTH, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)
		for _, unit in pairs(units) do
			self:LaunchProjectile(caster, unit, projectile_speed)
		end
	else
		self:LaunchProjectile(caster, target, projectile_speed)
	end
	
	caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")

	local talent_3 = caster:FindAbilityByName(talent_name_3)

	if talent_3 and talent_3:GetLevel() ~= 0 and caster.ult_targets then
		local range_limit = self:GetCastRange(caster:GetAbsOrigin(), nil) + caster:GetCastRangeBonus()

		for i, unit in pairs(caster.ult_targets) do
			if not unit or unit:IsNull() then
				table.remove(caster.ult_targets, i)
			elseif unit:HasModifier("modifier_joe_black_song_debuff") or unit:HasModifier("modifier_joe_black_song_buff") then
				if unit:IsHero() and unit ~= target and unit ~= caster and not unit:IsIllusion() then
					local distance = (caster:GetOrigin() - unit:GetOrigin()):Length2D()
					if distance <= range_limit then
						self:LaunchProjectile(caster, unit, projectile_speed)
					end
				end
			end
		end
	end
end


function joe_black_face_of_death:LaunchProjectile(src, target, prj_speed)
	local particle_info = {
		Target = target,
		Source = src,
		Ability = self,
		EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
		bDodgeable = true,
		bProvidesVision = true,
		iMoveSpeed = prj_speed,
	    iVisionRadius = 0,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile( particle_info )
end

function joe_black_face_of_death:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	if not hTarget then return end

	hTarget:EmitSound("Hero_Abaddon.DeathCoil.Target")

	if hTarget:TriggerSpellAbsorb(self) then return end

	if hTarget:TriggerSpellReflect(self) then return end

	local caster = self:GetCaster()
	local team = caster:GetTeamNumber()

	local damage_pct = self:GetSpecialValueFor( "heal_percent") / 100
	local heal 		 = self:GetSpecialValueFor( "damage" ) + caster:GetIntellect()*damage_pct

	local damage_table = {
		victim 		= hTarget,
		attacker 	= caster,
		damage 		= heal,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability 	= self,
	}

	if hTarget:GetTeamNumber() == team then
		hTarget:Heal( heal, caster )
		SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, hTarget, heal, nil)
	elseif not hTarget:IsMagicImmune() then
		ApplyDamage(damage_table)
	end
end
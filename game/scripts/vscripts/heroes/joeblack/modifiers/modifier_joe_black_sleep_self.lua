modifier_joe_black_sleep_self = class({})

function modifier_joe_black_sleep_self:IsPurgable()
	return false
end

function modifier_joe_black_sleep_self:IsHidden()
	return true
end

function modifier_joe_black_sleep_self:OnCreated()
	if not IsServer() then return end
	self.target_table = {}
	self.sleep_tables = {}

	self.parent  = self:GetParent()
	if self.parent:IsIllusion() or not self.parent:IsRealHero() then return end
	self.ability = self:GetAbility()

	self.delay        		= self.ability:GetSpecialValueFor("delay")
	self.health_drain_const = self.ability:GetSpecialValueFor("health_drain_const") * self.delay
	self.health_drain_pct   = self.ability:GetSpecialValueFor("health_drain_pct") * self.delay / 100
	self.mana_drain_const 	= self.ability:GetSpecialValueFor("mana_drain_const") * self.delay
	self.mana_drain_pct     = self.ability:GetSpecialValueFor("mana_drain_pct") * self.delay / 100

	self.projectile_table = {
		Target 			  = nil,
		Source 			  = nil,
		Ability 		  = self.ability,
		EffectName 		  = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
		bDodgeable 		  = true,
		bProvidesVision   = true,
		iMoveSpeed 		  = prj_speed,
	    iVisionRadius 	  = 0,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
	}
	

	local talent_name    = "joe_black_special_sleep"
	local talent_ability = self:GetCaster():FindAbilityByName(talent_name)

	local damage_table = {
		attacker    = self.parent,
		victim      = nil,
		damage      = nil,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability     = self.ability
	}
	local talent_radius = 0
	local talent_speed  = 0

	Timers:CreateTimer(0, function()

		if not talent_ability then
			talent_ability = self:GetCaster():FindAbilityByName(talent_name)
		end

		if talent_ability and talent_ability:GetLevel() ~= 0 and talent_radius == 0 then
			talent_radius = talent_ability:GetSpecialValueFor("radius")
			talent_speed  = talent_ability:GetSpecialValueFor("speed")
		end	

		for entidx, enemy in pairs(self.target_table) do
			damage_table.victim = enemy
			damage_table.damage = enemy:GetHealth() * self.health_drain_pct + self.health_drain_const
			ApplyDamage(damage_table)

			enemy:ReduceMana(enemy:GetMana() * self.mana_drain_pct + self.mana_drain_const)

			if talent_radius ~= 0 then
				self:SpreadSleep(enemy, talent_radius, talent_speed)
			end

		end

		return self.delay
	end)
end

function modifier_joe_black_sleep_self:SpreadSleep(target, radius , speed)
	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(), 
		target:GetAbsOrigin(), 
		self.parent, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	if not target.sleep_table then
		target.sleep_table = {}
	end
	for _, unit in pairs(units) do
		local u_entindex = tostring(unit:entindex())
		if target ~= unit and not unit:IsMagicImmune()
		and target.sleep_time
		and self.sleep_tables
		and not self.sleep_tables[target.sleep_time][u_entindex]
		and not self.target_table[u_entindex] then

			self.sleep_tables[target.sleep_time][u_entindex] = true
			unit.sleep_time = target.sleep_time
			self.sleep_tables[target.sleep_time]['count'] = self.sleep_tables[target.sleep_time]['count'] + 1

			self.projectile_table.Source = target
			self.projectile_table.Target = unit
			self.projectile_table.iMoveSpeed = speed

			ProjectileManager:CreateTrackingProjectile( self.projectile_table )
		end
	end
end

function modifier_joe_black_sleep_self:RegisterSleepCast(target)
	target.sleep_time = tostring(GameRules:GetGameTime())
	--print("Registering sleep table [", target.sleep_time, "] for ", target:GetUnitName(), target:entindex())
	self.sleep_tables[target.sleep_time] = {}
	self.sleep_tables[target.sleep_time][tostring(target:entindex())] = true
	self.sleep_tables[target.sleep_time]['count'] = 1
end

function modifier_joe_black_sleep_self:SleepFinished(unit)
	--print("finished sleep for", unit:GetUnitName(), unit:entindex())
	self.sleep_tables[unit.sleep_time]['count'] = self.sleep_tables[unit.sleep_time]['count'] - 1
	if self.sleep_tables[unit.sleep_time]['count'] == 0 then
		--print("removed sleep table [", unit.sleep_time, "]")
		self.sleep_tables[unit.sleep_time] = nil
	end
end
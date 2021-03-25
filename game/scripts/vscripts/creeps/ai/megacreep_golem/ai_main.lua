require('lib/timers')

GOLEM_TICK_TIME 	= 0.5
GOLEM_CAST_TICK 	= 0.1
GOLEM_ALLY_AOE 		= 600
GOLEM_ENEMY_AOE 	= 1000 

GOLEM_FIREBALL_MIN_RANGE 		 = 600
GOLEM_METEOR_RAIN_MIN_RANGE 	 = 600
GOLEM_METEOR_RAIN_SEARCH_RANGE 	 = 400
GOLEM_MIN_ENEMIES_FOR_BURN_CLOSE = 2 
GOLEM_MIN_ENEMIES_FOR_METEOR 	 = 2 
ATTACK_BUFFER_RANGE 			 = 600 
BACK_TO_SPAWN_RANGE				 = 2000

GolemAI = class({}) or GolemAI

function Spawn(entityKeyValues)
	golem = GolemAI() 

	golem.golem = thisEntity

	golem.ability_fireball 		= thisEntity:FindAbilityByName("megacreep_ancient_golem_fireball")
	golem.ability_burn_close 	= thisEntity:FindAbilityByName("megacreep_ancient_golem_burn_close")
	golem.ability_burn_far	 	= thisEntity:FindAbilityByName("megacreep_ancient_golem_burn_far")
	golem.ability_meteor_rain 	= thisEntity:FindAbilityByName("megacreep_ancient_golem_meteor_rain")
	Timers:CreateTimer(GOLEM_TICK_TIME, function() return golem:OnTick() end )
end

function GolemAI:OnTick()
	local golem = self.golem 

	if not golem:IsAlive() or golem:IsDominated() or golem:IsIllusion() then 
		return nil
	end 

	-- Если он кастует - чуть побыстрее будем решать что делать, но уже в следующий раз 
	if self.ability_fireball:IsInAbilityPhase() then return GOLEM_CAST_TICK end 
	if self.ability_burn_close:IsInAbilityPhase() then return GOLEM_CAST_TICK end 
	if self.ability_burn_far:IsInAbilityPhase() then return GOLEM_CAST_TICK end 
	if self.ability_meteor_rain:IsInAbilityPhase() then return GOLEM_CAST_TICK end 

	self.last_health = self.last_health or golem:GetHealth() 

	local golem_pos = golem:GetAbsOrigin()

	if not self.spawn_pos then
		self.spawn_pos = golem_pos
	end 

	if (golem_pos - self.spawn_pos):Length() > BACK_TO_SPAWN_RANGE then
		golem:MoveToPosition(self.spawn_pos)
		return GOLEM_CAST_TICK
	end 

	local allies 	= self:FindAllies(golem_pos)
	local enemies 	= self:FindEnemies(golem_pos)

	local golem_health = golem:GetHealth() 

	local want_burn_close = self:CheckBurnClose(golem_pos, golem_health, enemies)
	local want_burn_far, position1 = self:CheckBurnFar(golem_pos, golem_health, enemies)
	local want_fireball, target = self:CheckFireball(golem_pos, enemies)
	local want_meteor_fall, position2 = self:CheckMeteorFall(golem_pos, golem_health, enemies)
	local want_any = want_burn_close or want_burn_far or want_fireball or want_meteor_fall

	if want_burn_close then
		golem:CastAbilityNoTarget(self.ability_burn_close, -1)
	end

	if want_burn_far then
		golem:CastAbilityOnPosition(position1, self.ability_burn_far, -1)
	end

	if want_fireball then
		golem:CastAbilityOnTarget(target, self.ability_fireball,-1)
	end

	if want_meteor_fall then
		golem:CastAbilityOnPosition(position2, self.ability_meteor_rain, -1)
	end
	if not want_any then
		local target_to_attack = golem:GetAttackTarget() 
		local want_attack = false
		for _, enemy in pairs(enemies) do 
			if not enemy:IsInvulnerable() and not enemy:IsAttackImmune() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				target_to_attack = enemy
				if target_to_attack then 
					if enemy:GetHealth() < target_to_attack:GetHealth() and (golem_pos - enemy:GetAbsOrigin()):Length() < ATTACK_BUFFER_RANGE then
						target_to_attack = enemy 
					end 
				end
			end 
		end
		
		local target_pos = target_to_attack and target_to_attack:GetAbsOrigin()
		if target_to_attack and target_pos and (target_pos - self.spawn_pos):Length() < BACK_TO_SPAWN_RANGE then
			golem:MoveToTargetToAttack(target_to_attack)
			want_attack = true
		end 

		if not want_attack then
			golem:MoveToPosition(self.spawn_pos)
		end 
	end
	self.last_health = golem_health
	return GOLEM_TICK_TIME
end



---------------------------------------------------------------------------------------------------------
function GolemAI:CheckBurnClose(golem_pos, golem_hp, enemies)
	if not self.ability_burn_close:IsFullyCastable() or not self.ability_burn_close:IsCooldownReady() then
		return false
	end
	local AOE = self.ability_burn_close:GetSpecialValueFor("radius")
	local nEnemiesInRadius = 0 
	for _, enemy in pairs(enemies) do
		if (enemy:GetAbsOrigin() - golem_pos):Length() < AOE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				nEnemiesInRadius = nEnemiesInRadius + 1 
			end 
		end 
	end 

	if nEnemiesInRadius >= GOLEM_MIN_ENEMIES_FOR_BURN_CLOSE then
		return true
	end
	--инвизякам писю
	if golem_hp < self.last_health and not self.golem:IsAttacking() then
		return true
	end 

	return false
end
---------------------------------------------------------------------------------------------------------
function GolemAI:CheckBurnFar(golem_pos, golem_hp, enemies)
	if not self.ability_burn_far:IsFullyCastable() or not self.ability_burn_far:IsCooldownReady() then
		return false, -1
	end

	local AOE = self.ability_burn_far:GetSpecialValueFor("distance")
	local nEnemiesInRadius = 0 
	local index = 0
	for _, enemy in pairs(enemies) do
		index = index + 1
		if (enemy:GetAbsOrigin() - golem_pos):Length() < AOE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				nEnemiesInRadius = nEnemiesInRadius + 1
			end 
		end 
	end 	
	if nEnemiesInRadius > 0 then
		return true, enemies[index]:GetAbsOrigin()
	end
	--инвизякам опять писюн
	if golem_hp < self.last_health and not self.golem:IsAttacking() then
		return true, self.golem:GetForwardVector()
	end 

	return false, -1
end
---------------------------------------------------------------------------------------------------------
function GolemAI:CheckFireball(golem_pos, enemies)
	if not self.ability_fireball:IsFullyCastable() or not self.ability_fireball:IsCooldownReady() then
		return false, -1
	end

	local AOE = self.ability_fireball:GetCastRange(golem_pos, self.golem)
	local nEnemiesInRadius = 0 
	local index = 0
	local distance = 0
	for _, enemy in pairs(enemies) do
		index = index + 1
		distance = (enemy:GetAbsOrigin() - golem_pos):Length()
		if distance < AOE and distance > GOLEM_FIREBALL_MIN_RANGE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				nEnemiesInRadius = nEnemiesInRadius + 1
			end 
		end 
	end 	

	if nEnemiesInRadius > 0 then
		return true, enemies[index]
	end

end
---------------------------------------------------------------------------------------------------------
function GolemAI:CheckMeteorFall(golem_pos, golem_hp, enemies)
	if not self.ability_meteor_rain:IsFullyCastable() or not self.ability_meteor_rain:IsCooldownReady() then
		return false, -1
	end

	local AOE = self.ability_meteor_rain:GetCastRange(golem_pos, self.golem)
	local index = 0
	local distance = 0
	for _, enemy in pairs(enemies) do
		index = index + 1
		distance = (enemy:GetAbsOrigin() - golem_pos):Length()
		if  distance < AOE and distance > GOLEM_METEOR_RAIN_MIN_RANGE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				local enemiesAround = 0
				for _,Enemy in pairs(enemies) do
					if Enemy ~= enemy and (enemy:GetAbsOrigin() - Enemy:GetAbsOrigin()):Length() < GOLEM_METEOR_RAIN_SEARCH_RANGE then
						enemiesAround = enemiesAround + 1
					end
				end
				if index ~= 0 and enemiesAround >= GOLEM_MIN_ENEMIES_FOR_METEOR then
					return true, enemies[index]:GetAbsOrigin()
				end
			end 
		end 
	end 	

	--третий раз инвизякам хуем по губам вожу
	if golem_hp < self.last_health and not self.golem:IsAttacking() then
		return true, self.golem:GetAbsOrigin()
	end 

end
---------------------------------------------------------------------------------------------------------

function GolemAI:FindAllies(pos)
	local allies = FindUnitsInRadius(self.golem:GetTeamNumber(),
                              pos,
                              nil,
                              GOLEM_ALLY_AOE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
	return allies or {} 
end 

function GolemAI:FindEnemies(pos)
	local enemies = {}
	local temp_enemies = FindUnitsInRadius(self.golem:GetTeamNumber(),
                              pos,
                              nil,
                              GOLEM_ENEMY_AOE,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                              FIND_ANY_ORDER,
                              false)
	if not temp_enemies then return enemies end 
	for _, enemy in pairs(temp_enemies) do 
		if self.golem:CanEntityBeSeenByMyTeam(enemy) then
			table.insert(enemies, enemy)
		end 
	end 
	return enemies 
end 

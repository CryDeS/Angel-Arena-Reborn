require('lib/timers')

BEAST_TICK_TIME 	= 0.5
BEAST_CAST_TICK 	= 0.1
BEAST_ALLY_AOE 		= 600
BEAST_ENEMY_AOE 	= 1200 

BEAST_JUMP_MIN_RANGE 		= 400
BEAST_MIN_ENEMIES_FOR_STOMP = 2 
LIFE_DRAIN_HP_PCT 			= 0.8 
ATTACK_BUFFER_RANGE 		= 500 
BACK_TO_SPAWN_RANGE			= 2000

------------------------------------------------------------------------------

BeastAI = class({}) or BeastAI

function BeastAI:OnTick()
--	print("OnTick")
	local beast = self.beast 

	if not beast:IsAlive() or beast:IsDominated() or beast:IsIllusion() then 
		return nil 
	end 

	-- Если он кастует - чуть побыстрее будем решать что делать, но уже в следующий раз 
	if self.ability_stomp:IsInAbilityPhase() then return BEAST_CAST_TICK end 
	if self.ability_jump:IsInAbilityPhase() then return BEAST_CAST_TICK end 
--	if self.ability_buff_haste:IsInAbilityPhase() then return BEAST_CAST_TICK end 
	if self.ability_tail_stomp:IsInAbilityPhase() then return BEAST_CAST_TICK end 
	if self.ability_life_drain:IsChanneling() then return BEAST_CAST_TICK end 
--	if self.ability_buff_bonus_as:IsInAbilityPhase() then return BEAST_CAST_TICK end 

	self.last_health = self.last_health or beast:GetHealth() 

	local beast_pos = beast:GetAbsOrigin()

	if not self.spawn_pos then
		self.spawn_pos = beast_pos
	end 

	if (beast_pos - self.spawn_pos):Length() > BACK_TO_SPAWN_RANGE then
		beast:MoveToPosition(self.spawn_pos)
		return BEAST_CAST_TICK
	end 

	local allies 	= self:FindAllies(beast_pos)
	local enemies 	= self:FindEnemies(beast_pos)

	------------------------------------------------------------------------------------
 	-- Behavior block 

	local beast_health = beast:GetHealth() 

	local want_something = false 

	local want_haste = self:BuffHasteTick( allies )
	local want_jump, jump_target = self:JumpTick( beast_pos, enemies )

	if want_haste then
		beast:CastAbilityNoTarget(self.ability_buff_haste, -1)
		want_something = true 
	end 

	if want_jump then
		beast:CastAbilityOnTarget(jump_target, self.ability_jump, -1)
		want_something = true 
	end 

	if not want_jump then
		local want_stomp, nTargets = self:StompTick( beast_pos, beast_health, enemies)

		if want_stomp then
			beast:CastAbilityNoTarget(self.ability_stomp, -1) 
			want_something = true 
		else 
			local want_backstomp, nTargetsBack = self:BackStompTick( beast_pos, beast_health, enemies)

			if want_backstomp then 
				beast:CastAbilityNoTarget(self.ability_tail_stomp, -1) 
				want_something = true 
			end 
		end


		if not want_something then 
			local want_lifedrain, lifedrain_target = self:LifeDrainTick( beast_pos, enemies )

			if want_lifedrain then
				beast:CastAbilityOnTarget(lifedrain_target, self.ability_life_drain, -1)
				want_something = true 
			end 
		end 
	end 

	if not want_something then
		local target_to_attack 		= beast:GetAttackTarget() 

		for _, enemy in pairs(enemies) do 
			if not enemy:IsInvulnerable() and not enemy:IsAttackImmune() and not enemy:IsInvisible() then 
				if target_to_attack then
					if enemy:GetHealth() < target_to_attack:GetHealth() and (beast_pos - enemy:GetAbsOrigin()):Length() < ATTACK_BUFFER_RANGE  then
						target_to_attack = enemy 
					end 
				else 
					target_to_attack = enemy 
				end 
			end 
		end
		local target_pos = target_to_attack and target_to_attack:GetAbsOrigin()
		if target_to_attack then
			want_something = true 
			if self:BuffAttackTick() then 
				beast:CastAbilityNoTarget(self.ability_buff_bonus_as, -1) 
			elseif target_pos and (target_pos - self.spawn_pos):Length() < BACK_TO_SPAWN_RANGE then
				beast:MoveToTargetToAttack(target_to_attack)
			else
				beast:MoveToPosition(self.spawn_pos)
			end
		end 
	end 

	if not want_something then
		if (beast:GetAbsOrigin() - self.spawn_pos):Length() > 50 then
			beast:MoveToPosition(self.spawn_pos)
		end
	end 

	------------------------------------------------------------------------------------

	self.last_health = beast_health

	return BEAST_TICK_TIME
end 

function BeastAI:FindAllies(pos)
	local allies = FindUnitsInRadius(self.beast:GetTeamNumber(),
                              pos,
                              nil,
                              BEAST_ALLY_AOE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)

	return allies or {} 
end 

function BeastAI:FindEnemies(pos)
	local enemies = {}

	local temp_enemies = FindUnitsInRadius(self.beast:GetTeamNumber(),
                              pos,
                              nil,
                              BEAST_ENEMY_AOE,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
                              FIND_ANY_ORDER,
                              false)

	if not temp_enemies then return enemies end 

	for _, enemy in pairs(temp_enemies) do 
		if self.beast:CanEntityBeSeenByMyTeam(enemy) then
			table.insert(enemies, enemy)
		end 
	end 

	return enemies 
end 

function BeastAI:StompTick( beast_pos, beast_hp, enemies )
	if not self.ability_stomp:IsFullyCastable() or not self.ability_stomp:IsCooldownReady() then
		return false, -1
	end

	local point = beast_pos + self.beast:GetForwardVector() * self.ability_stomp:GetSpecialValueFor("cast_offset")
	local AOE 	= self.ability_stomp:GetSpecialValueFor("radius")

	local nEnemiesInRadius = 0 

	for _, enemy in pairs(enemies) do
		if (enemy:GetAbsOrigin() - point):Length() < AOE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				nEnemiesInRadius = nEnemiesInRadius + 1 
			end 
		end 
	end 

 	-- Если поблизости есть > BEAST_MIN_ENEMIES_FOR_STOMP врагов
	if nEnemiesInRadius >= BEAST_MIN_ENEMIES_FOR_STOMP then
		return true, nEnemiesInRadius
	end 

	-- Либо если крип не бьет никого, но хп теряется, значит возможно кто-то с инвиза бьет
	if beast_hp < self.last_health and not self.beast:IsAttacking() then
		return true, 0
	end 

	return false, -1
end 


function BeastAI:BackStompTick( beast_pos, beast_hp, enemies )
	if not self.ability_tail_stomp:IsFullyCastable() or not self.ability_tail_stomp:IsCooldownReady() then
		return false, -1
	end

	local point = beast_pos + self.beast:GetForwardVector() * self.ability_tail_stomp:GetSpecialValueFor("cast_offset")
	local AOE 	= self.ability_tail_stomp:GetSpecialValueFor("radius")

	local nEnemiesInRadius = 0 

	for _, enemy in pairs(enemies) do
		if (enemy:GetAbsOrigin() - point):Length() < AOE then
			if not enemy:IsInvulnerable() and not enemy:IsInvisible() and not enemy:IsBuilding() then 
				nEnemiesInRadius = nEnemiesInRadius + 1 
			end 
		end 
	end 

 	-- Если поблизости есть > BEAST_MIN_ENEMIES_FOR_STOMP врагов
	if nEnemiesInRadius >= BEAST_MIN_ENEMIES_FOR_STOMP then
		return true, nEnemiesInRadius
	end 

	-- Либо если крип не бьет никого, но хп теряется, значит возможно кто-то с инвиза бьет
	if beast_hp < self.last_health and not self.beast:IsAttacking() then
		return true, 0
	end 

	return false, -1
end 

function BeastAI:LifeDrainTick( beast_pos, enemies )
	if not self.ability_life_drain:IsFullyCastable() or not self.ability_life_drain:IsCooldownReady() then
		return false, nil
	end

	if self.beast:GetHealth() / self.beast:GetMaxHealth() > LIFE_DRAIN_HP_PCT then
		return false, nil 
	end 

	if #enemies ~= 1 then
		return false, nil
	end 

	local enemy = enemies[1]

	if enemy:IsBuilding() or enemy:IsInvulnerable() or enemy:IsInvisible() then 
		return false, nil 
	end 
 
 	-- 650 - ability cast range 
	if (enemy:GetAbsOrigin() - beast_pos):Length() < 650 * 0.9 then
		return true, enemy
	else 
		return false, nil 
	end 
end 

function BeastAI:JumpTick( beast_pos, enemies )
	if not self.ability_jump:IsFullyCastable() then
		return false, nil
	end

	if #enemies ~= 1 then
		return false, nil
	end 

	local enemy = enemies[1]

	if enemy:IsBuilding() or enemy:IsInvulnerable() or enemy:IsInvisible() then 
		return false, nil 
	end 

	if (enemy:GetAbsOrigin() - beast_pos):Length() > BEAST_JUMP_MIN_RANGE then
		return true, enemy
	else 
		return false, nil 
	end 
end 

function BeastAI:BuffAttackTick()
	if not self.ability_buff_bonus_as:IsFullyCastable() or not self.ability_buff_bonus_as:IsCooldownReady() then 
		return false
	end 

	return true 
end 


function BeastAI:BuffHasteTick( ally_table )
	if not self.ability_buff_haste:IsFullyCastable() or not self.ability_buff_haste:IsCooldownReady()   then 
		return false
	end 

	local cast_near_ally = #ally_table > 1

	if cast_near_ally then
		return true, #ally_table
	else 
		return false
	end 
end 

-- Main entry point for AI 
function Spawn( entityKeyValues )
	beast = BeastAI() 

	beast.beast = thisEntity

	beast.ability_stomp 		= thisEntity:FindAbilityByName("megacreep_beast_stomp")
	beast.ability_jump 			= thisEntity:FindAbilityByName("megacreep_beast_jump")
	beast.ability_buff_haste 	= thisEntity:FindAbilityByName("megacreep_beast_haste")
	beast.ability_tail_stomp 	= thisEntity:FindAbilityByName("megacreep_beast_tail_stomp")
	beast.ability_life_drain 	= thisEntity:FindAbilityByName("megacreep_beast_life_drain")
	beast.ability_buff_bonus_as = thisEntity:FindAbilityByName("megacreep_beast_bonus_attackspeed")

	Timers:CreateTimer(BEAST_TICK_TIME, function() return beast:OnTick() end )
end

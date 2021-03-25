SimpleAIActions = SimpleAIActions or class({})

----------------------------------------------------------------------------------------------------
-- 							Ability [ cast ability ]
----------------------------------------------------------------------------------------------------

SimpleAIActions.Ability = SimpleAIActions.Ability or class({})

local Ability = SimpleAIActions.Ability

function Ability:Make(caster, ability, cast)
	local res = Ability()

	res.caster 	= caster
	res.ability = ability
	res.cast 	= cast

	res.id = "Ability" .. ability:GetName()

	return res
end

function Ability:ForbiddenThink()
	return self.ability:IsInAbilityPhase()
end

function Ability:Do(aoiEnemies, spawnPos, aoiRange)
	local ability = self.ability

	if ability:GetCooldownTimeRemaining() ~= 0 then return false end

	local caster = self.caster

	if caster:IsSilenced() then return false end

	return self.cast(caster, ability, aoiEnemies)
end

----------------------------------------------------------------------------------------------------
-- 							Attack [ find unit in AOI and attack ]
----------------------------------------------------------------------------------------------------

SimpleAIActions.Attack = SimpleAIActions.Attack or class({})

local Attack = SimpleAIActions.Attack

function Attack:Make(caster)
	local res = Attack()
	
	res.caster 	 = caster
	res.id = "Attack"

	return res
end

function Attack:Do(aoiEnemies, spawnPos, aoiRange)
	local caster = self.caster

	local currentTarget 

	local attackTarget = caster:GetAttackTarget()

	if #aoiEnemies ~= 0 then
		currentTarget = aoiEnemies[1]
		if currentTarget == attackTarget then return true end
	else
		currentTarget = attackTarget

		if currentTarget then return true end
	end

	if currentTarget and (currentTarget:GetAbsOrigin() - spawnPos):Length() > aoiRange then
		currentTarget = nil
	end

	if not currentTarget then return false end

	caster:Stop()
	caster:MoveToTargetToAttack(currentTarget)

	return true
end

function Attack:ForbiddenThink()
	return false
end

----------------------------------------------------------------------------------------------------
-- 								Back [ back to spawn point ]
----------------------------------------------------------------------------------------------------

SimpleAIActions.Back = SimpleAIActions.Back or class({})
local Back = SimpleAIActions.Back

function Back:Make(caster)
	local res = Back()

	res.caster = caster
	res.id = "BacktoSpawn"

	return res
end

function Back:Do(aoiEnemies, spawnPos, aoiRange)
	local caster = self.caster

	if (caster:GetAbsOrigin() - spawnPos):Length() > 50 then
		caster:Stop()
		caster:MoveToPosition(spawnPos)
	end

	return true
end

function Back:ForbiddenThink()
	return false
end

----------------------------------------------------------------------------------------------------
-- 						 ForceBack [ back to spawn point if too big range ]
----------------------------------------------------------------------------------------------------

SimpleAIActions.ForceBack = SimpleAIActions.ForceBack or class({})

local ForceBack = SimpleAIActions.ForceBack

function ForceBack:Make(caster)
	local res = ForceBack()
	
	res.subact = Back:Make(caster)
	res.id = "ForceBackToSpawn"

	return res
end

function ForceBack:Do(aoiEnemies, spawnPos, aoiRange)
	local caster = self.subact.caster

	if (caster:GetAbsOrigin() - spawnPos):Length() > aoiRange + 50 then
		return self.subact:Do(aoiEnemies, spawnPos, aoiRange)
	end

	return false
end

function ForceBack:ForbiddenThink()
	return false
end
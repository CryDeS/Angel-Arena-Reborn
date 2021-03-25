local pets = {}

function SpawnPet(keys)
	local caster = keys.caster
	local pos = caster:GetAbsOrigin() + RandomVector(RandomFloat(100, 100))
	local pet_type = keys.Pet
	local pid = caster:GetPlayerOwnerID() 

	if pets[pid] then
		if IsValidEntity(pets[pid]) and pets[pid]:IsAlive() then
			pets[pid]:ForceKill(true)
			pets[pid] = nil
		end
	end

	if pet_type == "hulk" then
		SpawnHulk(caster, pid, pos)
	elseif pet_type == "wolf" then
		SpawnWolf(caster, pid, pos)
	elseif pet_type == "mage" then
		SpawnMage(caster, pid, pos)
	end
end

function SpawnHulk(caster, playerid, pos)
	local team = caster:GetTeamNumber() 


	PrecacheUnitByNameAsync("npc_aa_ancient_hulk", function(...)
		pets[playerid] = CreateUnitByName("npc_aa_ancient_hulk", pos, true, caster, caster, team)
		Timers:CreateTimer(.04, function()
     		pets[playerid]:SetControllableByPlayer(caster:GetPlayerID(), true)
  		end)
	end)
end

function SpawnWolf(caster, playerid, pos)
	local team = caster:GetTeamNumber() 


	PrecacheUnitByNameAsync("npc_aa_ancient_wolf", function(...)
		pets[playerid] = CreateUnitByName("npc_aa_ancient_wolf", pos, true, caster, caster, team)
		Timers:CreateTimer(.04, function()
     		pets[playerid]:SetControllableByPlayer(caster:GetPlayerID(), true)
  		end)
	end)
end

function SpawnMage(caster, playerid, pos)
	local team = caster:GetTeamNumber() 


	PrecacheUnitByNameAsync("npc_aa_ancient_mage", function(...)
		pets[playerid] = CreateUnitByName("npc_aa_ancient_mage", pos, true, caster, caster, team)
		Timers:CreateTimer(.04, function()
     		pets[playerid]:SetControllableByPlayer(caster:GetPlayerID(), true)
  		end)
	end)
end
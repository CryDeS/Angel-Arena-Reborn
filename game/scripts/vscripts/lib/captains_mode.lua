CM = class({})

local BUTTON_CAPTAIN = 0
local BUTTON_BAN = 1 
local BUTTON_SELECT = 2 
local BUTTON_PICK = 3 

local ARENA_STAGE_CAPTAIN = -1
local ARENA_STAGE_BAN = 0
local ARENA_STAGE_PICK = 1
local ARENA_STAGE_UNDEFINED = 2
local DOTA_TEAM_BOTH = -1 

local CAP_PICK_TIME = 15
local BAN_TIME = 60
local PICK_TIME = 60
local GAME_START_TIME = 30
local RADIANT_PLAYERS = 5 
local DIRE_PLAYERS = 5 

local _DEBUG = true

if _DEBUG and IsInToolsMode() then
	BAN_TIME = 10
	PICK_TIME = 10
end

local team_captains = {}
local radiant_bans = {}
local dire_bans = {} 
local radiant_picks = {}
local dire_picks = {}
local stage_done = {}
local stage = 0
local cur_timer = CAP_PICK_TIME
local picked_heroes = {}
local is_picked = {}
local tHeroList = {}  -- loaded 'scripts/npc/herolist.txt' file

local STAGE_TIMES = {
	[0]  = { time = CAP_PICK_TIME, stage_type 	= ARENA_STAGE_CAPTAIN,  	team = DOTA_TEAM_BOTH, 		slot = 0 },
	[1]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 1 },
	[2]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 1 },
	[3]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 2 },
	[4]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 2 },
	[5]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 3 },
	[6]  = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 3 },

	[7]  = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_GOODGUYS, 	slot = 1 },
	[8]  = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_BADGUYS, 	slot = 1 },
	[9]  = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_BADGUYS, 	slot = 2 },
	[10] = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_GOODGUYS, 	slot = 2 },


	[11] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 4 },
	[12] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 4 },

	[13] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 5 },
	[14] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 5 },

	[15] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_BADGUYS, 	slot = 3 },
	[16] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_GOODGUYS, 	slot = 3 },
	[17] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_BADGUYS, 	slot = 4 },
	[18] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_GOODGUYS, 	slot = 4 },

	[19] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_BADGUYS, 	slot = 6 },
	[20] = { time = BAN_TIME, stage_type 		= ARENA_STAGE_BAN,  		team = DOTA_TEAM_GOODGUYS, 	slot = 6 },

	[21]  = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_GOODGUYS, 	slot = 5 },
	[22]  = { time = PICK_TIME, stage_type 		= ARENA_STAGE_PICK,  		team = DOTA_TEAM_BADGUYS, 	slot = 5 },

	[23] = { time = GAME_START_TIME, stage_type = ARENA_STAGE_UNDEFINED, 	team = DOTA_TEAM_BOTH, 		slot = 0 },
}

-- -1 = UNDEFINED, 0 = BAN RADIANT, 1 = SELECT RADIANT, 2 = PICK HERO, 3 = BAN DIRE, 4 = SELECT DIRE

function CM:OnCaptainSelected( keys )
	local captain_id = keys.playerID
	local team_id = PlayerResource:GetTeam(captain_id)

	if team_captains[team_id] == -1 then
		team_captains[team_id] = captain_id
		-- TODO SEND EVENT TO BECOME CAPTAIN
		
		CustomNetTables:SetTableValue( "captains_mode", "team_captains", team_captains )
		CustomGameEventManager:Send_ServerToAllClients("cm_captain_select_accept", { captain_id = captain_id, team = team_id } )
		CustomGameEventManager:Send_ServerToTeam(team_id, "cm_set_stage_button", { bt_type = BUTTON_CAPTAIN, active = false } )
		print("set captain for team", team_id, "captain id = ", captain_id)
	else 
		print("fail, captain already set, captain = ", team_captains[team_id], "fake captain = ", captain_id)
	end

end

function CM:GetHeroForPick(playerid)
	for hero, pid in pairs(picked_heroes) do
		if pid == playerid then 
			return hero 
		end
	end

	return ""
end

function CM:OnGameStateChange( keys )
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		PauseGame(true)
		Timers:CreateTimer("CM_STAGE_0", 
		{
			endtime = 1,
			useGameTime = false,
			callback = CM._OnTimerThinks,
		})
	end

	--[[
	if state == DOTA_GAMERULES_STATE_PRE_GAME then
		for i = 0, 9 do
			if PlayerResource:PlayerResource:GetSelectedHeroName(i) ~= CM:GetHeroForPick(i) then
				PlayerResource:ReplaceHeroWith( i, CM:GetHeroForPick(i), 625, 0 )
			end

		end
	end]]
end

function CM:PickForAllNoobs()
	print("starting picking for noobs")
	for i = 0, 9 do
		if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then

			if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
				for hero_name, _ in pairs(radiant_picks) do
					if not picked_heroes[hero_name] then
						CM:_PickHero(i, hero_name, DOTA_TEAM_GOODGUYS)
						break;
					end
				end
			end

			if PlayerResource:GetTeam(i) == DOTA_TEAM_BADGUYS then
				for hero_name, _ in pairs(dire_picks) do
					if not picked_heroes[hero_name] then
						CM:_PickHero(i, hero_name, DOTA_TEAM_BADGUYS)
						break;
					end
				end
			end

		end
	end
end

function CM:_NextStage(reason)
	print("change state from", stage, "to", stage +1)
	if stage ~= #STAGE_TIMES then
		CM:_OnStageEnded(stage, reason)
	end 

	Timers:RemoveTimer("CM_STAGE_" .. stage)

	stage = stage + 1;
	
	if stage == #STAGE_TIMES then
		PauseGame(false)
	end

	if stage > #STAGE_TIMES then
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_SELECT, active = false } )
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_BAN, active = false } )
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_PICK, active = false } )
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_CAPTAIN, active = false } )

		print("pick for all noobs")
		CM:PickForAllNoobs()

		return
	end

	print("Starting stage", stage)
	CM:_StartStage(stage)
	CustomGameEventManager:Send_ServerToAllClients("cm_captain_stage_changed", { stage = stage } )
	CustomNetTables:SetTableValue( "captains_mode", "stage", { stage = stage } )
end

function CM:_OnStageEnded( stage, reason )
	print("stage ended = ", stage, reason)
	

	if stage == 0 then
		for i = 0, 9 do
			if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
				if team_captains[DOTA_TEAM_GOODGUYS] == -1 and PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
					CM:OnCaptainSelected( {playerID = i } )
					print("Select captain radiant = ", i)
				end

				if team_captains[DOTA_TEAM_BADGUYS] == -1 and PlayerResource:GetTeam(i) == DOTA_TEAM_BADGUYS then
					CM:OnCaptainSelected( {playerID = i } )
					print("Select captain dire = ", i)
				end
			end
		end

	end

	if CM:_GetArenaStage(stage) == 1 or CM:_GetArenaStage(stage) == 4 then
		if not stage_done[stage] then
			local playerid = -1 
			local team = -1 
			local hero_name = CM:_GetRandomHero()

			while not CM:_IsAvilableHero(hero_name) do
				hero_name = CM:_GetRandomHero()
			end

			if CM:_GetArenaStage(stage) == 1 then
				team = DOTA_TEAM_GOODGUYS
				playerid = team_captains[DOTA_TEAM_GOODGUYS]
			end 

			if CM:_GetArenaStage(stage) == 4 then
				team = DOTA_TEAM_BADGUYS
				playerid = team_captains[DOTA_TEAM_BADGUYS]
			end
			print("Select hero ", hero_name, " for team", team, " stage = ", _stage)
			CM:_SelectHero(hero_name, team)
		end
	end
end

function CM:_GetArenaStage( _stage )
	if not STAGE_TIMES or not STAGE_TIMES[_stage] then return -1 end

	local cur_stage_type = STAGE_TIMES[_stage].stage_type
	local cur_team = STAGE_TIMES[_stage].team 

	if(stage == #STAGE_TIMES) then
		print("arena stage == 2")
		return 2
	end

	if(cur_stage_type == ARENA_STAGE_BAN and cur_team == DOTA_TEAM_GOODGUYS) then
		print("arena stage == 0")
		return 0
	end

	if(cur_stage_type == ARENA_STAGE_PICK and cur_team == DOTA_TEAM_GOODGUYS) then
		print("arena stage == 1")
		return 1
	end

	if(cur_stage_type == ARENA_STAGE_BAN and cur_team == DOTA_TEAM_BADGUYS) then
		print("arena stage == 3")
		return 3
	end

	if(cur_stage_type == ARENA_STAGE_PICK and cur_team == DOTA_TEAM_BADGUYS) then
		print("arena stage == 4")
		return 4
	end

	print("arena stage == -1 stage/team:", cur_stage_type, cur_team)

	return -1
end

function CM:_Shuffle(tbl)
	local temp = {}

	for i,x in pairs(tbl) do
		if(x == 1) then
			table.insert(temp, i)
		end
	end

	local j = RandomInt(1, #temp)

	for i = 1,#temp do
		if( i ~= j ) then
			local val = temp[i]
			temp[i] = temp[j]
			temp[j] = val
		end
	end

	return temp
end

function CM:_GetRandomHero()
	local tst = tHeroList
	local rnd = #tst 
	local tst2 =  CM:_Shuffle(tst)
	
	return tst2[RandomInt(1, #tst2)]
end

function CM:_StartStage( stage )
	cur_timer = STAGE_TIMES[stage].time

	Timers:CreateTimer("CM_STAGE_" .. stage, 
	{
		endtime = 1,
		useGameTime = false,
		callback = CM._OnTimerThinks,
	})

	local stage_type = STAGE_TIMES[stage].stage_type 
	local stage_team = STAGE_TIMES[stage].team 
	local stage_slot = STAGE_TIMES[stage].slot 
	local player 

	if stage_team == DOTA_TEAM_GOODGUYS then
		player = PlayerResource:GetPlayer(team_captains[DOTA_TEAM_GOODGUYS])
	end

	if stage_team == DOTA_TEAM_BADGUYS then
		player = PlayerResource:GetPlayer(team_captains[DOTA_TEAM_BADGUYS])
	end

	if stage_type == ARENA_STAGE_CAPTAIN then
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_CAPTAIN, active = true } )
	end

	CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_SELECT, active = false } )
	CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_BAN, active = false } )

	if stage_type == ARENA_STAGE_PICK then
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage", { stage_id = stage_type, slot = stage_slot, team = stage_team } )
		CustomGameEventManager:Send_ServerToPlayer(player, "cm_set_stage_button", { bt_type = BUTTON_SELECT, active = true } )
	end

	if stage_type == ARENA_STAGE_BAN then
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage", { stage_id = stage_type, slot = stage_slot, team = stage_team } )
		CustomGameEventManager:Send_ServerToPlayer(player, "cm_set_stage_button", { bt_type = BUTTON_BAN, active = true } )
	end

	if stage_type == ARENA_STAGE_UNDEFINED then
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage", { stage_id = stage_type, slot = 999, team = stage_team } )
		CustomGameEventManager:Send_ServerToAllClients("cm_set_stage_button", { bt_type = BUTTON_PICK, active = true } )
	end

end

function CM:_OnTimerThinks()
	if not cur_timer then
		return 
	end

	if stage > #STAGE_TIMES then return end
	
	if not _G.captains_mode_paused then
		cur_timer = cur_timer - 1
	end
	--print("timer thinks, stage = ", stage, "timer = ", cur_timer)

	local t = cur_timer
	local minutes = math.floor(t / 60)
    local seconds = t - (minutes * 60)
    local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
    local s01 = seconds - (s10 * 10)
    local timer_text 
    if m10 == 0 then
    	timer_text = m01 .. ":" .. s10 .. s01
    else
    	timer_text = m10 .. m01 .. ":" .. s10 .. s01
    end

   	if stage ~= #STAGE_TIMES then 
   		PauseGame(true)
	
		CustomGameEventManager:Send_ServerToAllClients("cm_captain_timer", { time = timer_text } )
	end

	if(cur_timer == 0) then
	
		CM:_NextStage(0)
		return nil
	end

	return 1
end

function CM:_IsCaptain(playerid)
	for i, x in pairs(team_captains) do
		if(x == playerid) then
			return true 
		end
	end

	return false 
end

function CM:_IsAvilableHero(hero_name)
	local tst = tHeroList

	if not radiant_bans[hero_name] and not dire_bans[hero_name] and not radiant_picks[hero_name] and not dire_picks[hero_name] and tst[hero_name] == 1 then
		return true 
	end 

	return false
end

function CM:_BanHero(hero_name, team)
	if team == DOTA_TEAM_GOODGUYS then
		radiant_bans[hero_name] = STAGE_TIMES[stage].slot
	else
		dire_bans[hero_name] = STAGE_TIMES[stage].slot
	end
	print("ban hero = ", hero_name, "from team = ", team)
	CustomGameEventManager:Send_ServerToAllClients("cm_captain_banned", { stage = stage, slot = STAGE_TIMES[stage].slot, team = team, hero_name = hero_name } )
	CustomNetTables:SetTableValue( "captains_mode", "banned_heroes", { radiant_bans = radiant_bans, dire_bans = dire_bans} )
end

function CM:_SelectHero(hero_name, team)
	if team == DOTA_TEAM_GOODGUYS then
		radiant_picks[hero_name] = STAGE_TIMES[stage].slot
	else
		dire_picks[hero_name] = STAGE_TIMES[stage].slot
	end
	stage_done[stage] = 1

	CustomGameEventManager:Send_ServerToAllClients("cm_captain_selected_hero", { stage = stage, slot = STAGE_TIMES[stage].slot, team = team, hero_name = hero_name } )
	CustomNetTables:SetTableValue( "captains_mode", "selected_heroes", { radiant_picks = radiant_picks, dire_picks = dire_picks} )

	PrecacheUnitByNameAsync(hero_name, function() end)
end

function CM:_PickHero(playerid, hero_name, team)
	if picked_heroes[hero_name] then
		print("hero already picked for someone", hero_name, stage)
		return
	end
	
	if is_picked[playerid] then
		print("hero already picked")
		return 
	end

	if team == DOTA_TEAM_GOODGUYS then
		if not radiant_picks[hero_name] then 
			print("wrong hero, this is enemy hero ")
			return 
		end
	end

	if team == DOTA_TEAM_BADGUYS then
		if not dire_picks[hero_name] then 
			print("wrong hero, this is enemy hero ")
			return 
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("cm_picked", { playerid = playerid, team = team, hero_name = hero_name } )
	print("picking hero:", hero_name, " for playerid = ", playerid)
	
	picked_heroes[hero_name] = playerid
	is_picked[playerid] = true 

	local player = PlayerResource:GetPlayer(playerid)

	PlayerResource:SetGold(playerid, 625, true)
	PlayerResource:SetGold(playerid, 0, false)

	PrecacheUnitByNameAsync( hero_name, function(...) end)

	CustomNetTables:SetTableValue( "captains_mode", "picked_heroes", picked_heroes )
end

function CM:_IsTeamStage(team, _stage)
	if CM:_GetArenaStage(_stage) == -1 then return false end 
	
	if team == DOTA_TEAM_GOODGUYS then
		if CM:_GetArenaStage(_stage) <= 2 then
			return true 
		end
	else 
		if CM:_GetArenaStage(_stage) >= 2 then
			return true 
		end
	end
	print("not team stage ", _stage)
	return false 
end

function CM:OnSelectedHero(keys)
	local playerid = keys.playerid
	local team = PlayerResource:GetTeam(playerid)
	local hero_name = keys.hero_name

	if not CM:_IsTeamStage(team, stage) then 
		print("NOT TEAM STAGE")
		return 
	end

	if CM:_GetArenaStage(stage) == 2 then
		CM:_PickHero(playerid, hero_name, team)
		print("_PICK HERO")
		return 
	end

	if not CM:_IsAvilableHero(hero_name) then 
		print("NOT AVALI HERO = ", hero_name)
		return 
	end

	if not (team_captains[team] == playerid) then
		print("its not captain")
		return
	end

	if CM:_GetArenaStage(stage) == 0 or CM:_GetArenaStage(stage) == 3 then
		CM:_BanHero(hero_name, team)
		print("BAN HERO ", hero_name," TEAM = ", team)
	end

	if CM:_GetArenaStage(stage) == 1 or CM:_GetArenaStage(stage) == 4  then
		CM:_SelectHero(hero_name, team)
		print("SELECT HERO ", hero_name," TEAM = ", team)
	end

	CM:_NextStage(1)
end

function CM:OnConnectFull(keys)
	local entIndex 		= keys.index+1
    local player 		= EntIndexToHScript(entIndex)
    local player_id 	= player:GetPlayerID() 

	PlayerResource:SetCanRepick(player_id, false)

    if stage >= #STAGE_TIMES then return end 

    local stage_type = STAGE_TIMES[stage].stage_type 

    if team_captains[DOTA_TEAM_GOODGUYS] == player_id or team_captains[DOTA_TEAM_BADGUYS] == player_id then
    	
    	if stage_type == ARENA_STAGE_PICK then
    		CustomGameEventManager:Send_ServerToPlayer(player, "cm_set_stage_button", { bt_type = BUTTON_SELECT, active = true } )
    	end

    	if stage_type == ARENA_STAGE_BAN then
    		CustomGameEventManager:Send_ServerToPlayer(player, "cm_set_stage_button", { bt_type = BUTTON_BAN, active = true } )
    	end
    end
end

function CM:_SelectRandomHeroes()

end

function CM:_Init()
	print("MAP NAME = ", GetMapName())
	
	if GetMapName() ~= "map_5x5_cm" then return end 

	_G.is_cm_mode = true

	tHeroList = LoadKeyValues('scripts/npc/herolist.txt')
	CustomGameEventManager:RegisterListener("cm_captain_selected", Dynamic_Wrap(CM, 'OnCaptainSelected'))
	CustomGameEventManager:RegisterListener("cm_selected", Dynamic_Wrap(CM, 'OnSelectedHero'))
	team_captains = {}
	team_captains = {}
	radiant_bans = {}
	dire_bans = {} 
	radiant_picks = {}
	dire_picks = {}
	stage = 0
	cur_timer = CAP_PICK_TIME
	picked_heroes = {}
	team_captains[DOTA_TEAM_GOODGUYS] = -1;
	team_captains[DOTA_TEAM_BADGUYS] = -1;
	CustomNetTables:SetTableValue( "captains_mode", "team_captains", team_captains )
	CustomNetTables:SetTableValue( "captains_mode", "stage", { stage = stage } )
	CustomNetTables:SetTableValue( "captains_mode", "banned_heroes", { radiant_bans = radiant_bans, dire_bans = dire_bans} )
	CustomNetTables:SetTableValue( "captains_mode", "selected_heroes", { radiant_picks = radiant_picks, dire_picks = dire_picks} )
	CustomNetTables:SetTableValue( "captains_mode", "picked_heroes", picked_heroes )
	ListenToGameEvent('game_rules_state_change', 		Dynamic_Wrap(CM, 'OnGameStateChange'), self)
	ListenToGameEvent('player_connect_full', 			Dynamic_Wrap(CM, 'OnConnectFull'), self)

	CM:OnGameStateChange()
end

CM:_Init()
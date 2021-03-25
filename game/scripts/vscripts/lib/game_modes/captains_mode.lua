require('lib/kv_preloaded_data')
require('lib/team_helper')

CaptainsMode = CaptainsMode or class({})

CaptainsMode.RandomHeroOnShowcase = false

local TEAMLIST = {DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS}

local STAGE_UNDEFINED, STAGE_CAPTAINS_PICK, STAGE_PICK, STAGE_BAN, STAGE_PICK_HEROES = 0, 1, 2, 3, 4

local STAGE_TIMES = {
	[STAGE_UNDEFINED] 	  = 0,
	[STAGE_CAPTAINS_PICK] = 15,
	[STAGE_PICK] 		  = 30,
	[STAGE_BAN] 		  = 30,
	[STAGE_PICK_HEROES]	  = 30,
}

local BASE_GOLD = 625
local RESERVE_TIME = 120
local INVALID_TEAM = -1

local STAGE_LIST = {
	{ STAGE_CAPTAINS_PICK, INVALID_TEAM },
	
	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },
	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },

	{ STAGE_PICK, DOTA_TEAM_GOODGUYS },
	{ STAGE_PICK, DOTA_TEAM_BADGUYS },
	{ STAGE_PICK, DOTA_TEAM_GOODGUYS },
	{ STAGE_PICK, DOTA_TEAM_BADGUYS },

	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },
	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },
	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },

	{ STAGE_PICK, DOTA_TEAM_BADGUYS },
	{ STAGE_PICK, DOTA_TEAM_GOODGUYS },
	{ STAGE_PICK, DOTA_TEAM_BADGUYS },
	{ STAGE_PICK, DOTA_TEAM_GOODGUYS },

	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },
	{ STAGE_BAN,  DOTA_TEAM_GOODGUYS },
	{ STAGE_BAN,  DOTA_TEAM_BADGUYS },

	{ STAGE_PICK, DOTA_TEAM_GOODGUYS },
	{ STAGE_PICK, DOTA_TEAM_BADGUYS },

	{ STAGE_PICK_HEROES, INVALID_TEAM },
}

function CaptainsMode:InitGameMode()
	GameRules:SetHeroSelectionTime(50)
	GameRules:SetStrategyTime(10)

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CaptainsMode, '_OnGameStateChange'), self)

	CustomGameEventManager:RegisterListener("aa_cm_captain_select", Dynamic_Wrap(CaptainsMode, '_OnCaptainSelected'))
	CustomGameEventManager:RegisterListener("aa_cm_hero_pick", 		Dynamic_Wrap(CaptainsMode, '_OnHeroPicked'))
	CustomGameEventManager:RegisterListener("aa_cm_hero_ban", 		Dynamic_Wrap(CaptainsMode, '_OnHeroBanned'))
	CustomGameEventManager:RegisterListener("aa_cm_hero_choice", 	Dynamic_Wrap(CaptainsMode, '_OnHeroChoiced'))
	CustomGameEventManager:RegisterListener("aa_cm_ask_update", 	Dynamic_Wrap(CaptainsMode, '_AskUpdate'))
end

function CaptainsMode:_InitCM()
	local heroList = PreloadCache:GetHeroList()

	self.allowedHeroes = shallowcopy( heroList )

	local randomHeroes = {}
	for heroName, bNeed in pairs(self.allowedHeroes) do
		if bNeed then
			table.insert(randomHeroes, heroName)
		end
	end

	self.randomHeroes = randomHeroes

	ShuffleTable( self.randomHeroes )

	self:_UpdateAllowedHeroList()

	self.teamCaptains = {}
	self.pickedHeroes = {}
	self.bannedHeroes = {}
	self.choicedHeroes = {}
	self.pickedPlayers = {}
	self.reserveTime = {}

	for _, team in pairs(TEAMLIST) do
		self.teamCaptains[team] = INVALID_TEAM
		self.pickedHeroes[team] = {}
		self.bannedHeroes[team] = {}
		self.choicedHeroes[team] = {}
		self.pickedPlayers[team] = {}
		self.reserveTime[team] = RESERVE_TIME
	end

	self.nStage    = 0
	self.nCaptains = 0

	self.stageFuncs = {}
	self.paused = false
	self.useReserveTime = false

	self:NextStage( false )
end

function CaptainsMode:_OnGameStateChange( keys )
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		PauseGame(true)

		self:NextStage()

		self.timer = Timers:CreateTimer({
			endtime = 1,
			useGameTime = false,
			callback = function()
				if CaptainsMode:_OnTick() then
					return 1
				end

				return nil
			end
		})
	end
end

function CaptainsMode:NextStage( bForce )
	local newStage = self.nStage + 1

	self.nStage = newStage

	local stageInfo = STAGE_LIST[newStage]

	if not stageInfo then
		self.stage = nil
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_end", {} )
		PauseGame(false)
		return false 
	end

	local stage, stageTeam = unpack(stageInfo)

	if bForce then
		local wasStage = self.stage

		if wasStage == STAGE_PICK then
			self:_ForcePick(stageTeam)
		elseif wasStage == STAGE_PICK_HEROES then
			self:_ForcePickHero()
		elseif wasStage == STAGE_CAPTAINS_PICK then
			self:_ForcePickCaptain()
		elseif wasStage == STAGE_BAN then
			self:_ForceBan(stageTeam)
		end
	end

	self.stage 		  = stage
	self.nCurrentTeam = stageTeam
	self.time 		  = STAGE_TIMES[stage]

	if stage == STAGE_UNDEFINED then
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_start", { reserveTime = RESERVE_TIME } )
	elseif stage == STAGE_CAPTAINS_PICK then
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_stage_choice_captains", { time = self.time } )
	elseif stage == STAGE_PICK then
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_stage_pick", { time = self.time, team = self.nCurrentTeam } )
	elseif stage == STAGE_BAN then 
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_stage_ban", { time = self.time, team = self.nCurrentTeam } )
	elseif stage == STAGE_PICK_HEROES then
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_stage_pick_heroes", { time = self.time } )
	end

	return true
end

function CaptainsMode:_ForcePick( nTeam )
	local randomHeroes = self.randomHeroes

	for _, heroName in pairs(randomHeroes) do
		if not self.allowedHeroes[heroName] then
			self:_OnHeroPickedReal(team, heroName)
			return
		end
	end

	error("[CaptainsMode] No free heroes for pick. That must never happens")
end

function CaptainsMode:_ForceBan( nTeam )
	self:_OnHeroBannedReal( nTeam, "" )
end	

function CaptainsMode:_ForcePickHero()
	for _, team in pairs(TEAMLIST) do
		local pickedHeroes = self.pickedHeroes[team]
		local pickedPlayers = self.pickedPlayers[team]
		local choicedHeroes = self.choicedHeroes[team]

		TeamHelper:ApplyForPlayers( team, function(playerID)
			if not pickedPlayers[playerID] then
				for _, heroName in pairs(pickedHeroes) do
					if choicedHeroes[heroName] == -1 then
						self:_OnHeroChoicedReal( team, playerID, heroName)
						break
					end
				end

				return true
			end
		end)
	end
end

function CaptainsMode:_ForcePickCaptain()
	for _, team in pairs(TEAMLIST) do
		local captain = self.teamCaptains[team]

		if captain == INVALID_TEAM then
			TeamHelper:ApplyForPlayers( team, function(playerID)
				if PlayerResource:IsConnected(playerID) then
					self:_OnCaptainSelectedReal(team, playerID)
					return true
				end

				return false
			end)
		end
	end
end

function CaptainsMode:_OnCaptainSelected( data )
	if self.stage ~= STAGE_CAPTAINS_PICK then
		print("[CaptainsMode] Failed to set captain, now not captains pick")
		return
	end

	local playerID = data.playerID

	if not PlayerResource:IsValidPlayerID(playerID) then return end

	local team = PlayerResource:GetTeam(playerID)

	if self.teamCaptains[team] ~= INVALID_TEAM then
		print("[CaptainsMode] Failed to set captain to team", team, "playerID", playerID, "captain already selected")
		return
	end

	self:_OnCaptainSelectedReal(team, playerID)

	if newCaptainsCount >= #TEAMLIST then
		self:NextStage( false )
	end
end

function CaptainsMode:_OnCaptainSelectedReal( team, playerID )
	self.teamCaptains[team] = playerID
	CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_captain_selected", { team = team, playerID = playerID } )
	local newCaptainsCount = self.nCaptains + 1
	self.nCaptains = newCaptainsCount
end

function CaptainsMode:_OnHeroPicked( data )
	if self.stage ~= STAGE_PICK then
		print("[CaptainsMode] Failed to pick hero, now not hero picking stage")
		return
	end

	local heroName = data.heroName

	if not heroName then 
		print("[CaptainsMode] Failed to pick hero, invalid hero name", heroName)
		return 
	end

	if not self.allowedHeroes[heroName] then 
		print("[CaptainsMode] Failed to pick hero, that hero is unavailable", heroName)
		return 
	end

	local playerID = data.playerID

	if not PlayerResource:IsValidPlayerID(playerID) then  
		print("[CaptainsMode] Failed to pick hero, player id sender is invalid", heroName, playerID)
		return  
	end

	local team = PlayerResource:GetTeam(playerID)

	if not self.teamCaptains[team] == playerID then
		print("[CaptainsMode] Failed to pick hero, player is not captain", playerID, "must be id", self.teamCaptains[team])
		return
	end

	self:_OnHeroPickedReal( team, heroName )

	self:NextStage( false )
end

function CaptainsMode:_OnHeroPickedReal( team, heroName )
	table.insert( self.pickedHeroes[team], heroName )
	self.allowedHeroes[heroName] = false
	self.choicedHeroes[team][heroName] = -1
	CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_hero_pick", { team = team, heroName = heroName } )
end

function CaptainsMode:_OnHeroBanned( data )
	if self.stage ~= STAGE_BAN then
		print("[CaptainsMode] Failed to ban hero, now not hero picking stage")
		return
	end

	local heroName = data.heroName

	if not heroName then 
		print("[CaptainsMode] Failed to ban hero, invalid hero name", heroName)
		return 
	end

	if not self.allowedHeroes[heroName] then 
		print("[CaptainsMode] Failed to ban hero, that hero is unavailable", heroName)
		return 
	end

	local playerID = data.playerID

	if not PlayerResource:IsValidPlayerID(playerID) then  
		print("[CaptainsMode] Failed to ban hero, player id sender is invalid", heroName, playerID)
		return  
	end

	local team = PlayerResource:GetTeam(playerID)

	if not self.teamCaptains[team] == playerID then
		print("[CaptainsMode] Failed to ban hero, player is not captain", playerID, "must be id", self.teamCaptains[team])
		return
	end

	self:_OnHeroBannedReal( team, heroName )

	self:NextStage( false )
end

function CaptainsMode:_OnHeroBannedReal( team, heroName )
	table.insert( self.bannedHeroes[team], heroName )
	self.allowedHeroes[heroName] = false
	CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_hero_ban", { team = team, heroName = heroName } )
end

function CaptainsMode:_OnHeroChoiced( data )
	if self.stage ~= STAGE_PICK_HEROES then
		print("[CaptainsMode] Failed to choice hero, now not hero choicing stage")
		return
	end

	local heroName = data.heroName

	if not heroName then 
		print("[CaptainsMode] Failed to choice hero, invalid hero name", heroName)
		return 
	end

	local playerID = data.playerID

	if not PlayerResource:IsValidPlayerID(playerID) then  
		print("[CaptainsMode] Failed to choice hero, player id sender is invalid", heroName, playerID)
		return  
	end

	local team = PlayerResource:GetTeam(playerID)

	if self.choicedHeroes[team][heroName] ~= -1 then
		print("[CaptainsMode] Failed to choice hero, choiced hero is not available", heroName, playerID, team)
		return  
	end

	self:_OnHeroChoicedReal( team, playerID, heroName )	
end

function CaptainsMode:_OnHeroChoicedReal( team, playerID, heroName)
	self.choicedHeroes[team][heroName] = playerID
	self.pickedPlayers[team][playerID] = true

	CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_hero_choice", { team = team, heroName = heroName, playerID = playerID } )

	PrecacheUnitByNameAsync( heroName, function(...) end)

	local hero = CreateHeroForPlayer(heroName, PlayerResource:GetPlayer(playerID))
	hero:RemoveSelf()

	PlayerResource:SetGold(playerID, BASE_GOLD, true)
	PlayerResource:SetGold(playerID, 0, false)
end

function CaptainsMode:_AskUpdate( data )
	local playerID = data.playerID

	if not PlayerResource:IsValidPlayerID(playerID) then  
		print("[CaptainsMode] Failed to ask update, invalid playerID", playerID)
		return  
	end

	local player = PlayerResource:GetPlayer(playerID)

	if not player or player:IsNull() then
		print("[CaptainsMode] Failed to ask update, invalid player", playerID)
	end

	local time = self.time
	local team = self.nCurrentTeam
	local useReserveTime = self.useReserveTime

	if useReserveTime then
		time = self.reserveTime[team]
	end

	local pickedHeroes
	local bannedHeroes
	local reserveTimes
	local choicedHeroes

	local stage = self.stage

	if stage ~= nil then
		pickedHeroes = self.pickedHeroes
		bannedHeroes = self.bannedHeroes
		reserveTimes = self.reserveTimes
		choicedHeroes = self.choicedHeroes
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "aa_cm_on_update_info", 
	{ 
		time 		   = time, 
		team 		   = team,
		useReserveTime = useReserveTime,
		stage 		   = self.stage,
		pickedHeroes   = pickedHeroes,
		bannedHeroes   = bannedHeroes,
		reserveTime    = self.reserveTime,
		choicedHeroes  = choicedHeroes,
	})
end

function CaptainsMode:_UpdateAllowedHeroList()
	CustomNetTables:SetTableValue( "captains_mode", "heroList", self.allowedHeroes )
end

function CaptainsMode:_OnTick()
	PauseGame( true )

	if self.paused then return true end

	local stage = self.stage
	local team = self.nCurrentTeam

	local newTime = self.time - 1

	local useReserveTime = false

	if newTime < 0 then
		local nextStage = false

		if team ~= INVALID_TEAM then
			newTime = self.reserveTime[team] - 1

			if newTime >= 0 then
				self.reserveTime[team] = newTime
				useReserveTime = true
			else
				nextStage = true
			end
		else
			nextStage = true
		end
	else
		self.time = newTime
	end

	self.useReserveTime = useReserveTime

	if nextStage then
		return self:NextStage( true )
	else
		CustomGameEventManager:Send_ServerToAllClients("aa_cm_on_timer", { time = newTime, useReserveTime = useReserveTime } )
		return true
	end
end

CaptainsMode:_InitCM()
--[[ Overrides for PlayerResource and Player entity 
   
   API:
	PlayerResource:IsDisconnected(playerid)
	PlayerResource:SetDisconnected(playerid)
	PlayerResource:IsConnected(playerid)
	PlayerResource:SetConnected(playerid)
	PlayerResource:IsAbandoned(playerid)
	PlayerResource:SetAbandoned(playerid)
	PlayerResource:GetAllHeroes()
	PlayerResource:GetHeroes(iTeamNumber)
	PlayerResource:RegisterOnAbandonedCallback(callback)
	PlayerResource:ClearOnAbandonedCallbacks()

   Callback must be called from main callbacks
    PlayerResource:OnPlayerConnected(playerid, userid) 
]]


------------------------------------------------------------------------------------------------------------------------------------------------

require("lib/timers")

local TIME_TO_LEAVE = 300

------------------------------------------------------------------------------------------------------------------------------------------------

function PlayerResource:__InitCustomPlayerResource() 
	if self.__internal__ then return end 

	self.__internal__ = self.__internal__ or {}

	self.__internal__["callbacks"] = {
		["onAbandoned"] = {},
	}

	self.__internal__["playerid_dict_connection_states"] = {
		[DOTA_CONNECTION_STATE_UNKNOWN] 			= {},
		[DOTA_CONNECTION_STATE_NOT_YET_CONNECTED] 	= {},
		[DOTA_CONNECTION_STATE_CONNECTED] 			= {},
		[DOTA_CONNECTION_STATE_DISCONNECTED] 		= {},
		[DOTA_CONNECTION_STATE_ABANDONED] 			= {},
		[DOTA_CONNECTION_STATE_LOADING] 			= {},
		[DOTA_CONNECTION_STATE_FAILED] 				= {},
	}

	self.__internal__["playerid_info"] = {
		["connection_times"] = {}
	}
	
	self.__internal__.userIDs = self.__internal__.userIDs or {} -- tbl[playerid] = userid 

	Timers:CreateTimer(1.0, function() 
		PlayerResource:__Tick() 
		return 1.0 
		end)
end 

function PlayerResource:RegisterOnAbandonedCallback(callback)
	table.insert(self.__internal__["callbacks"]["onAbandoned"], callback)
end 

function PlayerResource:ClearOnAbandonedCallbacks()
	self.__internal__["callbacks"]["onAbandoned"] = {} 	
end 

function PlayerResource:_TriggerOnAbandoned(playerid)
	for _, callback in pairs(self.__internal__["callbacks"]["onAbandoned"]) do
		callback({ playerid = playerid })
	end 
end 
	 
function PlayerResource:IsDisconnected(playerid)
	local val = (PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_DISCONNECTED )

	local internalValue = self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_DISCONNECTED][playerid]

	if internalValue ~= nil then 
		val = internalValue
	end 

    return val 
end 

function PlayerResource:SetDisconnected(playerid, v)
	self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_DISCONNECTED][playerid] = v
end 

function PlayerResource:IsConnected(playerid)
    local val = (PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_CONNECTED )

    if PlayerResource:IsFakeClient(playerid) then return true end
    
    local internalValue = self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_CONNECTED][playerid]

	if internalValue ~= nil then 
		val = internalValue
	end 

    return val  
end 

function PlayerResource:SetConnected(playerid, v)
	self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_CONNECTED][playerid] = v
end 

function PlayerResource:IsAbandoned(playerid)
    local val = (PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_ABANDONED )

    local internalValue = self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_ABANDONED][playerid]
	if internalValue ~= nil then 
		val = internalValue
	end 

    return val 
end 

function PlayerResource:SetAbandoned(playerid, v)
	local oldv = self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_ABANDONED][playerid]

	self.__internal__["playerid_dict_connection_states"][DOTA_CONNECTION_STATE_ABANDONED][playerid] = v

	if oldv ~= v and v == true then
		print("OnPlayerForceAbaddoned ", playerid)
		self:_TriggerOnAbandoned(playerid)
	end 
end 

function PlayerResource:GetAllHeroes()
	local result = {}

	for playerid = 0, PlayerResource:GetPlayerCount() - 1 do
		local ent = PlayerResource:GetSelectedHeroEntity( playerid )
		
		if ent and IsValidEntity(ent) and ent:IsRealHero() then
			result[playerid] = ent 
		end 
	end 

	return result 
end 

function PlayerResource:GetHeroes(iTeamNumber)
	local result = {}

	for playerid = 0, PlayerResource:GetPlayerCount() do
		if PlayerResource:GetTeam(playerid) == iTeamNumber then 
			local ent = PlayerResource:GetSelectedHeroEntity( playerid )

			if ent and IsValidEntity(ent) and ent:IsRealHero() then
				result[playerid] = ent 
			end 
		end 
	end 

	return result 
end 

function PlayerResource:ForceDisconnect(playerid)
	if not self.__internal__.userIDs[playerid] then return end 

	SendToServerConsole('kickid '.. tostring(self.__internal__.userIDs[playerid]));
end 

-- Callback that must be called from main gamemode
function PlayerResource:OnPlayerConnected(playerid, userid)
	self.__internal__.userIDs[playerid] = userid 

	if self:IsAbandoned(playerid) then
		ForceDisconnect(playerid)
	end 
end 

function PlayerResource:__Tick()
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return end 
	if GameRules:State_Get() > DOTA_GAMERULES_STATE_POST_GAME then return end 

	for playerid = 0, PlayerResource:GetPlayerCount() do
		local v = self.__internal__["playerid_info"]["connection_times"][playerid] or TIME_TO_LEAVE

		if not PlayerResource:IsConnected(playerid) then 

			if v > 0 then
				v = v - 1
				
				if v == 0 or PlayerResource:IsAbandoned(playerid) then
					v = 0
					print("OnPlayerForceDisconnect in tick", playerid)
					PlayerResource:SetAbandoned(playerid, true)
				end 
			end 

			self.__internal__["playerid_info"]["connection_times"][playerid] = v
		end 
	end 
end 

PlayerResource:__InitCustomPlayerResource() 
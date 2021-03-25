PanoramaPingManager = PanoramaPingManager or {}

function PanoramaPingManager:OnKillimitGet(data)
	local playerid = data['PlayerID']
	local text = data['s']
	
	local player = PlayerResource:GetPlayer(playerid)

	if not player then return end

	local team = PlayerResource:GetTeam(playerid)
	local enemy_team = DOTA_TEAM_GOODGUYS

	if team == DOTA_TEAM_GOODGUYS then
		enemy_team = DOTA_TEAM_BADGUYS
	elseif team ~= DOTA_TEAM_BADGUYS then
		return
	end

	local kl = _G.KILL_LIMIT
	local myteamkills = PlayerResource:GetTeamKills(team)
	local enemykills = PlayerResource:GetTeamKills(enemy_team)
	
	local need_myteam = max(kl - myteamkills, 0)
	local need_enemyteam = max(kl - enemykills, 0)

	text = text:format( need_myteam, need_enemyteam )

	Say(player, ">" .. text, true)
end

function PanoramaPingManager:OnDuelGet(data)
	local playerid = data['PlayerID']
	local text = data['s']
	
	local player = PlayerResource:GetPlayer(playerid)

	if not player then return end

	Say(player, ">" .. text, true)
end

CustomGameEventManager:RegisterListener("on_kill_limit_click", Dynamic_Wrap(PanoramaPingManager, 'OnKillimitGet'))
CustomGameEventManager:RegisterListener("on_duel_timer_click", Dynamic_Wrap(PanoramaPingManager, 'OnDuelGet'))


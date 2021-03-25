require('lib/attentions')
require('lib/team_helper')

ComebackSystem = ComebackSystem or class({})

local BASE_ADDITIONAL_GOLD_PER_KILL = 100
local BASE_ADDITIONAL_GOLD_PER_MINUTE = 7
local BASE_GOLD_PER_STREAK = 200
local BASE_GOLD_PER_STREAK_PER_MIN = 35
local KILLS_TO_GOLD_COMEBACK = 8
local GOLD_TO_TEAMMATES = 40
local TEAM_MATE_AOE = 1200

-- [ (level, goldDiff ), ...]
local GoldDifferenceTable = {
	{ 0, 250 },
	{ 5, 750 },
	{ 10, 1000 },
	{ 15, 1250 },
	{ 20, 1500 },
	{ 25, 2000 },
}

local function GiveGoldTo( playerid, gold, isAssist )
	if not PlayerResource:IsValidPlayerID( playerid ) then return end

	PlayerResource:ModifyGold(playerid, gold, true, DOTA_ModifyGold_HeroKill)

	local msg = "#ANGEL_ARENA_ON_KILL"

	if isAssist then
		msg = "#ANGEL_ARENA_ON_ASSIST"
	end

	Attentions:SendChatMessage( msg, playerid, gold )
end

function ComebackSystem:_GetTeamGold( team )
	return self.teamGolds[team] or 0
end

function ComebackSystem:_FindGoldDifferenceStamp( time )
	local result

	for _, data in pairs(GoldDifferenceTable) do
		local timeStamp  = data[1]
		local goldResult = data[2]

		if timeStamp < time or result == nil then
			result = goldResult
		end

		if time > timeStamp then
			break
		end
	end

	return result or 0
end

function ComebackSystem:OnGiveGold( playerid, gold, isReliable, reason )
	local team = PlayerResource:GetTeam( playerid )

	self.teamGolds[ team ] = (self.teamGolds[ team ] or 0) + gold
end

function ComebackSystem:OnKill( killerPlayerID, killerTeam, victimPlayerID, victimTeam )
	if killerTeam == victimTeam then return end
	if killerTeam ~= DOTA_TEAM_GOODGUYS and killerTeam ~= DOTA_TEAM_BADGUYS then 
		print("invalid team", killerTeam)
		return 
	end

	local deadHero = PlayerResource:GetSelectedHeroEntity( victimPlayerID )

	if not deadHero or deadHero:IsNull() or not IsValidEntity(deadHero)  then return end

	local deadHeroPos = deadHero:GetAbsOrigin()

	local minute = GameRules:GetDOTATime( false, false ) / 60

	local baseGold = BASE_ADDITIONAL_GOLD_PER_KILL + minute * BASE_ADDITIONAL_GOLD_PER_MINUTE

	local streakGold = PlayerResource:GetStreak( victimPlayerID ) * (BASE_GOLD_PER_STREAK + minute * BASE_GOLD_PER_STREAK_PER_MIN)

	local killerTeamGold = self:_GetTeamGold( killerTeam )
	local victimTeamGold = self:_GetTeamGold( victimTeam )

	local nHalfPlayersTotal = TeamHelper:GetPlayerCount(nil) / 2
	local teamGoldMinDiff = self:_FindGoldDifferenceStamp( minute ) / nHalfPlayersTotal
	
	local teamGoldDiff = victimTeamGold - killerTeamGold
	local teamGoldDiffNormalized = (victimTeamGold / TeamHelper:GetPlayerCount(victimTeam) - killerTeamGold / TeamHelper:GetPlayerCount(killerTeam)) * nHalfPlayersTotal

	local totalGold = baseGold + streakGold

	if teamGoldDiffNormalized > teamGoldMinDiff then
		totalGold = totalGold + teamGoldDiff / KILLS_TO_GOLD_COMEBACK
	end

	local nPlayers = 0

	local function Check( teammatePlayerID, hero )
		if teammatePlayerID == killerPlayerID then return false end

		if (hero:GetAbsOrigin() - deadHeroPos):Length() > TEAM_MATE_AOE then return false end

		return true
	end

	TeamHelper:ApplyForHeroes(killerTeam, function( teammatePlayerID, hero )
		if Check( teammatePlayerID, hero ) then
			nPlayers = nPlayers + 1
		end
	end)

	if nPlayers ~= 0 then
		local goldPct = GOLD_TO_TEAMMATES / 100

		local teamMateGold = totalGold * goldPct

		totalGold = totalGold - teamMateGold

		teamMateGold = teamMateGold / nPlayers

		TeamHelper:ApplyForHeroes(killerTeam, function( teammatePlayerID, hero )
			if Check( teammatePlayerID, hero ) then
				GiveGoldTo(teammatePlayerID, teamMateGold, true)
			end
		end)
	end

	GiveGoldTo(killerPlayerID, totalGold, false)
end

function ComebackSystem:_Init()
	self.teamGolds = {}
end

ComebackSystem:_Init()

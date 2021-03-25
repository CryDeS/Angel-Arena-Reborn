require('lib/message_formatters')

GameEnder = GameEnder or class({})

local TIME_TO_END 		  = 30
local END_MESSAGE 		  = "#game_ends_on_30_sec"
local END_MINIMAP_MESSAGE = "#game_ends_on_time"

function GameEnder:_OnEnd(team)
	GameRules:SetGameWinner(team)
end

function GameEnder:ForceEnd(iTeamNumber)
	local timer = self.endTimer

	if timer then
		Timers:RemoveTimer(timer)
		self.endTimer = nil
	end

	self:_OnEnd(iTeamNumber)
end

function GameEnder:StartGameEnd(iTeamNumber)
	Attentions:SendAttentionText(END_MESSAGE, 10, 2)

	local func = function()
		if self:_OnTick() then return nil end

		return 1
	end

	self.nCountdown = TIME_TO_END + 1
	self.endTeam 	= iTeamNumber
	self.endTimer 	= Timers:CreateTimer(func(), func)
end

function GameEnder:_OnTick()
	local time = self.nCountdown - 1

	if time == -1 then
		self:_OnEnd(self.endTeam)
		return true
	else
		self.nCountdown = time
		self:_UpdateCountdownUI()
	end

	return false
end

function GameEnder:_UpdateCountdownUI()
	local timeStr = MessageFormaters:FormatTime(self.nCountdown)
	local color = "#FFFF00"

	Attentions:SetTextMinimapText( END_MINIMAP_MESSAGE, color, { ["time"] = timeStr } )
end
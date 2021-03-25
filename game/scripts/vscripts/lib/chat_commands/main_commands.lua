Commands = Commands or class({})

------------------------------------------------------------------------------------------------------------

local cooldowns = {}

function Commands:pausecm( player, arg )
	local pid = player:GetPlayerID()

	if cooldowns[pid] then 
		Say(player, "> Pause not available", true)
		return 
	end

	cooldowns[pid] = 1

	Say(player, "> Pause the game", true)

	Timers:CreateTimer(10, function() cooldowns[pid] = nil end)

	_G.captains_mode_paused = true
end 

function Commands:unpausecm( player, arg )
	_G.captains_mode_paused = false
	Say(player, "> Unpause the game", true)
end 



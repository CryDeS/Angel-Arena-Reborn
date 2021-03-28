--[[
Wrapper for mouse cursor position (in world space) request

API
 - MouseCursor:OnCursorPosition(playerid, callback) 
    - requests a mouse cursor position of a player, calls `callback` with it as a first argument

 - MouseCursor:OnNearestUnit(player, callback, radius)
    - requests a mouse cursor position of a player, searches for nearest unit around that point,
    - calls `callback` with this unit as a first argument.
    - `radius` is optional, defaults to 100.

]]

MouseCursor = MouseCursor or class({})

function MouseCursor:Init()
    self.pending_requests = {}
    CustomGameEventManager:RegisterListener("MouseCursor:CursorPositionReport", function(_, event)
        MouseCursor:__CursorPositionReport(event)
    end)
end

function MouseCursor:__CursorPositionReport(event)
	local player_id = event.PlayerID
	local event_id = event.event_id
	local vec = Vector( 
		tonumber(event.cursorPosition["0"]), 
		tonumber(event.cursorPosition["1"]), 
		tonumber(event.cursorPosition["2"])
	)
	SafeCall(self.pending_requests[event_id], vec)
    Timers:RemoveTimer(event_id)
	self.pending_requests[event_id] = nil
end

function MouseCursor:OnCursorPosition(playerid, callback) 
	local event_id = DoUniqueString("cursor_call")
	self.pending_requests[event_id] = callback
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "MouseCursor:RequestCursorPosition", {
		event_id = event_id
	})
    -- cleanup in case event is never received
    Timers:CreateTimer(event_id, {
        endTime = 10,
        callback = function()
            if self.pending_requests[event_id] then
                self.pending_requests[event_id] = nil
            end
        end
    })
end

function MouseCursor:OnNearestUnit(player, callback, radius)
	MouseCursor:OnCursorPosition(player:GetPlayerID(), function(position)
		if not player then return end
		if not radius then radius = 100 end
		
		local nearest_unit = _GetNearestUnitUnderPoint(position, radius)
		if not nearest_unit then
			nearest_unit = player:GetAssignedHero()
		end
		if not nearest_unit then return end

		SafeCall(callback, nearest_unit)
	end)
end

MouseCursor:Init()
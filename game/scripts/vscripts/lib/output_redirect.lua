require('lib/admins')
require('debug')

OutputRedirection = OutputRedirection or class({})
OutputRedirection._data = OutputRedirection._data or {}
OutputRedirection._count = 0

function OutputRedirection:isConnected(playerid)
	return self._data[playerid] ~= nil
end

function OutputRedirection:connect(playerid, value)
	if value then
		self._data[playerid] = 1
		self._count = self._count + 1
	elseif self:isConnected(playerid) then
		self._data[playerid] = nil
		self._count = self._count - 1
	end
end

local function _outputData(playerid, sData, isError)
	local player = PlayerResource:GetPlayer(playerid)

	if not player then 
		OutputRedirection:connect(playerid, false)
		return false
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "AADebugPrintMessage", { print_value = sData, is_error = isError })

	return true
end

if not IsInToolsMode() then 
	debug._originalTraceback = debug._originalTraceback or debug.traceback
	_G._originalPrint = _G._originalPrint or _G.print 

	local _print 	 = _G._originalPrint
	local _traceback = debug._originalTraceback

	function print_wrapper(...)
		local result = _print(...)

		if OutputRedirection._count > 0 then
			local nArgs = select("#", ...)
			local myStr = ""

			for i = 1, nArgs do
				myStr = myStr .. tostring( select(i, ...) )
			end

			for playerid, _ in pairs(OutputRedirection._data) do
				if not _outputData( playerid, myStr, false ) then break end
			end
		end

		return result
	end

	function traceback_wrapper()
		local result = _traceback()

		if OutputRedirection._count > 0 then
			for playerid, _ in pairs(OutputRedirection._data) do
				if not _outputData( playerid, result, true ) then break end
			end
		end

		return result
	end

	_G["print"] = print_wrapper
	debug.traceback = traceback_wrapper
end
function merge_table(tbl1, tbl2)
	for k,v in pairs(tbl2) do
		if type(v) == 'table' and tbl1[k] then
			merge_table(tbl1[k], v)
		else
			tbl1[k] = v
		end
	end
end

function dir(t) 
	local res = ""

	for i,x in pairs(t) do
		res = res .. tostring(i) .. ": " .. tostring(x) .. "\n"
	end 	

	return res:sub(0, #res-1)
end 

function print_table(t)
	print( dir(t) )
end

function ShuffleTable(someTable, randFunc)
	if not randFunc then
		randFunc = RandomInt
	end
	
	for idx, x in pairs(someTable) do
		local i = randFunc(1, #someTable)

		if i ~= idx then
			local temp = x
			someTable[idx] = someTable[i]
			someTable[i] = temp
		end
	end

	return someTable 
end

local function _format_force_print( ... )
	local text = ""

	local nArgs = select("#", ...)

	for i = 1, nArgs do
		text = text .. " " .. tostring( select(i, ...) )
	end

	return text
end

function force_print( ... )
	local text = _format_force_print( ... )

	CustomGameEventManager:Send_ServerToAllClients("DebugMessage", { msg = text })
end

function force_print_player( player, ... )
	local text = _format_force_print( ... )

	CustomGameEventManager:Send_ServerToPlayer(player, "DebugMessage", { msg = text })
end

function SafeCall(func, ...)
	local arg = {...}

	local status, result = xpcall(function() return func(unpack(arg)) end, 
								  function (msg) return msg .. '\n' .. debug.traceback() .. '\n' end)

	return result
end

function Safe_Wrap(mt, name)
	local func = Dynamic_Wrap(mt, name)

	local result = function(...)
		return SafeCall( func, ... )
	end

	return result
end
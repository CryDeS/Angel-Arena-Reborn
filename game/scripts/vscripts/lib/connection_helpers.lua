function IsDisconnected(unit)
	if not unit or unit:IsNull() or not IsValidEntity(unit) then
		return false
	end

	local playerid = unit:GetPlayerOwnerID()
	if playerid == -1 or playerid == nil then
		return false
	end

	return PlayerResource:IsDisconnected(playerid)
end

function IsConnected(unit)
	if not unit or unit:IsNull() or not IsValidEntity(unit) or unit:IsNull() then
		return false
	end

	local playerid = unit:GetPlayerOwnerID()

	if playerid == -1 or playerid == nil then
		return true
	end

	return PlayerResource:IsConnected(playerid)
end

function IsAbadonedPlayerID(playerid)
	return PlayerResource:IsAbandoned(playerid)
end

function IsAbadoned(unit)
	if not unit or unit:IsNull() or not IsValidEntity(unit) then return false end

	local playerid = unit:GetPlayerOwnerID()
	if playerid == -1 or playerid == nil then
		return false
	end

	return IsAbadonedPlayerID(playerid)
end
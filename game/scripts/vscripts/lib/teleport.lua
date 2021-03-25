--[[

	TeleportUnitToVector(hscript unit, vector vec, bool stop, bool cam) - teleport unit to vector point ( u can use "Vector(x, y, z)" to convert 3 number to vector type )

	TeleportUnitToEntity(hscript unit, hscript ent, bool stop, bool cam) - teleport unit to entity

	TeleportUnitToPointName(hscript unit, cstring point_name, bool stop, bool cam) - teleports unit to entity with name 'point_name' *use "point_target" for that please.

	SetPlayerCameraToEntity(int playerid, hscript entity) - sets player camera to entity
]]

local private = {};

function private:TeleportUnit(unit, vec)
	FindClearSpaceForUnit(unit, vec, false)
end

function TeleportUnitToVector(unit, vec, stop, cam)
	if not unit or not IsValidEntity(unit) then 
		return 
		print("[TS] Teleport system error, invalid unit")
	end

	if not vec then
		print("[TS] Teleport system error, Vector is nil! (in TeleportUnitToVector)")
		return
	end

	private:TeleportUnit(unit, vec)

	if stop == true then
		unit:Stop()
	end

	if cam == true then
		if not unit:IsRealHero() then return end
		local playerid = unit:GetPlayerOwnerID() 
		SetPlayerCameraToEntity(playerid, unit)
	end
end

function TeleportUnitToEntity(unit, ent, stop, cam)
	if not unit or not IsValidEntity(unit) then print("[TS] Teleport system error, invalid unit") return end
	if not ent or not IsValidEntity(ent) then print("[TS] Teleport system error, invalid entity") return end
	local vec = ent:GetAbsOrigin()

	if not vec then
		print("[TS] Teleport system error, Vector is nil! (in TeleportUnitToEntity)")
		return
	end

	private:TeleportUnit(unit, vec)

	if stop then
		unit:Stop()
	end

	if cam then
		if not unit:IsRealHero() then return end
		local playerid = unit:GetPlayerOwnerID() 
		SetPlayerCameraToEntity(playerid, unit)
	end
end

function GetPointPositionByName(pointName)
	local ent = Entities:FindByName(nil, pointName)
	
	if ent and IsValidEntity(ent) then
		return ent:GetAbsOrigin()
	end

	return nil
end

function TeleportUnitToPointName(unit, point_name, stop, cam)
	if type(point_name) ~= "string" then
		print("[TS] Teleport system error, invalid name, expected string, got " .. type(point_name) )
		return
	end
	local ent = Entities:FindByName(nil, point_name)
	if not ent or not IsValidEntity(ent) then
		print("[TS] Teleport system error, entity with name '" .. point_name .. "' doesnt exits!")
		return
	end
	TeleportUnitToEntity(unit, ent, stop, cam)
end

function SetPlayerCameraToEntity(playerid, entity)
	if not entity or not IsValidEntity(entity) or not playerid or not PlayerResource:IsValidPlayerID(playerid)then
		print("[TS] Teleport system error, invalid entity for set camera.")
		return
	end

	PlayerResource:SetCameraTarget(playerid, entity)
		Timers:CreateTimer(0.2, function()
			PlayerResource:SetCameraTarget(playerid, nil)
		end)
	
end
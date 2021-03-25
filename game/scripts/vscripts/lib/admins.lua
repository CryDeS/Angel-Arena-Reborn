require('lib/team_helper')

AngelArenaAdmins = AngelArenaAdmins or class({})

function AngelArenaAdmins:Init()
	local tohashtable = function(tbl)
		local res = {}
		for _, i in pairs(tbl) do
			res[i] = true
		end
		return res
	end

	self.ids = tohashtable({
		73911256,	-- crydes
		104356809,	-- sheodar
	})
end

function AngelArenaAdmins:IsAdminPlayerID(playerid)
	local steamid = PlayerResource:GetSteamAccountID( playerid )
	
	if steamid == nil then return false end

	return self.ids[steamid] ~= nil
end

function AngelArenaAdmins:ForeachAdminID( func )
	for id, _ in pairs(self.ids) do
		func(id)
	end
end

function AngelArenaAdmins:ForeachAdminInGame( func )
	if not self.adminsCache then
		self.adminsCache = {}

		TeamHelper:ApplyForPlayers( nil, function(playerID)
			if AngelArenaAdmins:IsAdminPlayerID( playerID ) then
				table.insert( self.adminsCache, playerID )
			end
		end)
	end

	for _, playerID in pairs( self.adminsCache ) do
		func( playerID )
	end
end

AngelArenaAdmins:Init()
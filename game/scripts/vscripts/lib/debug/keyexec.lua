require('lib/admins')

KeyExec = KeyExec or class({})

function KeyExec:_MakeKey( keyname, func )
	local oldHandler = self.handlers[keyname]

	if not oldHandler then
		Convars:RegisterCommand(keyname, function(...) 
				local handler = self.handlers[keyname]

				if handler then
					local player = Convars:GetCommandClient()
					handler(player)
				end
			end, 
			"debug only", 
			0)
	end

	self.handlers[keyname] = func
end

function KeyExec:Init()
	self.handlers = self.handlers or {}

	KeyExec:_MakeKey("aa_debug_exec_scrollock", function(player)
			if not AngelArenaAdmins:IsAdminPlayerID( player:GetPlayerID() ) then 
				print("Scrollock is not available for you")
				return 
			end

			package.loaded[ 'lib/debug/exscript' ] = nil
			
			require('lib/debug/exscript')

			print("Exec Success")
		end)

	KeyExec.KEY_HOME = KeyExec:_MakeKey("aa_debug_exec_mouse", function(player)
		if not player then return end

		local hero = player:GetAssignedHero()
		if not hero then return end

		MouseCursor:OnCursorPosition(player:GetPlayerID(), function(position)
			if not hero or hero:IsNull() then return end
			FindClearSpaceForUnit(hero, position, true)
		end)
	end)

	--OnDebugTeleport
end
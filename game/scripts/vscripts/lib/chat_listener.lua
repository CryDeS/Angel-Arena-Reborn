if ChatListener == nil then
	print ( '[ChatListener] created ChatListener' )
	ChatListener = {}
	ChatListener.__index = ChatListener
end

require("lib/chat_commands/cheat_commands")
require("lib/chat_commands/admin_commands")
require("lib/chat_commands/main_commands")

function ChatListener:OnPlayerChat(keys)
	local player_id = keys.playerid
	local player = PlayerResource:GetPlayer(keys.playerid)
	local text = keys.text

	local args = {}

	for i in string.gmatch(text, "%S+") do -- split string
		table.insert(args, i)
	end

	local command = args[1]
	
	if command:sub(1, 1) ~= "-" then return end

	table.remove(args, 1)

	local fixed_command = command:sub(2)

	if Commands[fixed_command] then
		Commands[fixed_command](Commands, player, args)
	end 
end
Attentions = Attentions or class({})

function Attentions:SetKillLimit( nCount )
	CustomNetTables:SetTableValue("game_info", "kill_limit", { kl = nCount })
end

function Attentions:SetTextMinimapText(text, color, formatters)
	if not formatters then
		formatters = {}
	end

	CustomNetTables:SetTableValue("game_info", "timer", { text = text, formatters = formatters, color = color })
end

function Attentions:SendChatMessage( msg, plyid, count )
	if plyid == nil then
		plyid = 0
	end

	if count == nil then
		count = 0
	end

	GameRules:SendCustomMessage(msg, plyid, count)
end

function Attentions:HideAttentionText()
	if self.attentionTextTimer then
		Timers:RemoveTimer( self.attentionTextTimer )
	end

	self:_HideAttentionText()
end

function Attentions:SendAttentionText(text, showTime, priority)
	priority = priority or 0

	-- ignore message with lower-priority
	if self.attentionTextTimer and priority < self.lastAttentionPriority then return end 

	self.lastAttentionPriority = priority

	CustomGameEventManager:Send_ServerToAllClients("attension_text", { string = text })
	self.attentionTextTimer = Timers:CreateTimer(showTime, function()
		self:HideAttentionText()
	end)
end


function Attentions:_HideAttentionText()
	CustomGameEventManager:Send_ServerToAllClients("attension_close", nil)
	self.attentionTextTimer = nil
end


function Attentions:_Init()
	self.attentionTextTimer = nil
	self.lastAttentionPriority = nil
end

Attentions:_Init()
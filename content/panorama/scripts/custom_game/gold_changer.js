"use strict";
var gold_label
var listener 
var player_id 
var unit
var data 
var gold 

function SetGold()
{
	player_id = Game.GetLocalPlayerID()
	unit = Players.GetLocalPlayerPortraitUnit()
	
	for(var i = 0; i < 19; i++)
	{
		if ( (Players.IsValidPlayerID(i) && (Players.GetTeam(i) == Players.GetTeam(player_id) ) ) )
		{
			var hero = Players.GetPlayerHeroEntityIndex(i);
			
			if(hero == unit)
			{
				player_id = i;
				break;
			}
		}
	}
	
	data = CustomNetTables.GetTableValue("gold", "player_id_" + player_id)
	
	if(!data || !data["gold"])
	{
		data = {}
		data["gold"] = 0
		$.Schedule(0.1, SetGold);
		return
	}
	
	if(!gold_label)
	{
		find_element();
		$.Schedule(0.1, SetGold);
		return;
	}
	
	gold = data["gold"]
	
	gold_label.text = gold
	//$.Msg("setgold: ", gold)
	$.Schedule(0.1, SetGold)
	if( listener != null)
	{
		CustomNetTables.UnsubscribeNetTableListener(listener)
		listener = null;
	}
}

function find_element()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	var quick_buy = dotaHud.FindChildTraverse("quickbuy")
	
	gold_label = quick_buy.FindChildTraverse("GoldLabel")
}

function FixRecomendedItems()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	var shop = dotaHud.FindChildTraverse("GuideFlyout")
	shop.style.visibility = "visible";
	
	$.Schedule(10, FixRecomendedItems)
}

function SendCursorPosition(event) {
	const cursorPosition = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());
	GameEvents.SendCustomGameEventToServer("MouseCursor:CursorPositionReport", {
		cursorPosition: cursorPosition,
		event_id: event.event_id
	})
}

(function()
{
	find_element()
	listener = CustomNetTables.SubscribeNetTableListener("gold", SetGold)
	GameEvents.Subscribe("MouseCursor:RequestCursorPosition", SendCursorPosition)
	SetGold()
	FixRecomendedItems()
})();




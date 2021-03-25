"use strict";

var g_bCanClick = true;

function UpdateDuelText()
{
	let data = CustomNetTables.GetTableValue( "game_info", "timer" )
	
	let baseText   = data.text
	let color 	   = data.color
	let formatters = data.formatters

	let textBlock = $( "#DuelTextBlock")
	
	for( let attrName in formatters )
		textBlock.SetDialogVariable(attrName, formatters[attrName] )
		
	textBlock.text = $.Localize(baseText, textBlock)	
	textBlock.style.color = color
}

function Attension_update(data)
{
	$( "#Attension").visible = true
	var temp_text = "";
	temp_text+=data.string;
	$( "#Attension").text = $.Localize(temp_text)
}
function Attension_close()
{
	$( "#Attension").visible = false
}


function OnKillimitClick()
{
	if( !GameUI.IsAltDown() )
		return;
	
	if(!OnClick())
		return;
	
	g_bCanClick = false;
	
	var localized = $.Localize("#angel_arena_kill_limit_click")
	
	GameEvents.SendCustomGameEventToServer("on_kill_limit_click", { "s" : localized } ); 
}

function OnTimerClick()
{
	if( !GameUI.IsAltDown() )
		return;
	
	if(!OnClick())
		return;
	
	var text = $( "#DuelTextBlock").text
	
	if( text == "" )
		return
	
	GameEvents.SendCustomGameEventToServer("on_duel_timer_click", { "s" : text } ); 
}

function OnClick()
{
	if(!g_bCanClick)
		return false;
	
	g_bCanClick = false;
	
	$.Schedule(2, function() { g_bCanClick = true; } )
	
	return true;
}
function Test()
{
	$.Msg("Test start");
	var father_panel = $("#TEST");
	
	father_panel.RemoveAndDeleteChildren()
	
	var panel = $.CreatePanel("DOTAShopItem", father_panel, "tst1");
	panel.AddClass("TST");
	panel.itemname = "item_azrael_crossbow"
	panel.style.opacity = "1"
	panel.visible = true
	panel = panel.FindChildTraverse("ItemImage")
	panel.itemname = "item_azrael_crossbow"
	
	$.Msg("Test end");
}

function UpdateKillLimit()
{
	var temp_text = CustomNetTables.GetTableValue( "game_info", "kill_limit" ).kl
	$("#KillLimit_text").text = temp_text
}

(function()
{
	CustomNetTables.SubscribeNetTableListener( "game_info", function()
	{
		UpdateDuelText()
		UpdateKillLimit()
	})

	GameEvents.Subscribe( "attension_text", Attension_update)
	GameEvents.Subscribe( "attension_close", Attension_close)
})();
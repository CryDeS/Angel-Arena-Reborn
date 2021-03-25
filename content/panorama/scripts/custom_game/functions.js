"use strict";

function LocalizeText(data)
{
	var string_output = $.Localize(data.string)
	var output_data = {
		string: string_output,
		priority: data.priority,
	}
	GameEvents.SendCustomGameEventToServer("ReciveLocalizeText", output_data );
}

function DebugPrintData(data)
{
    if (data == undefined || data == null || data == "") {return}
	var msg = data.msg
	if (msg == undefined || msg == null || msg == "") {return}
	if (typeof msg == "string") {
	    var arr = msg.split(" ")
        msg = ""
        arr.forEach(function(item, i, arr) {
          msg = msg + $.Localize(item) + " "
        });

    $.Msg(msg)
	}
}

function GetDotaHud() {
    var panel = $.GetContextPanel();
    while (panel && panel.id !== 'Hud') {
        panel = panel.GetParent();
	}

    if (!panel) {
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

function FindDotaHudElement(id) {
	return GetDotaHud().FindChildTraverse(id);
}

function MakeNeutralItemsInShopColored(id) 
{
	var itemGrid = FindDotaHudElement('GridNeutralItems');
	var items = itemGrid.FindChildrenWithClassTraverse('MainShopItem');
	
	itemGrid.GetParent().style.overflow = "clip scroll";
	
	for(var i = 0; i < items.length; i++)
	{
		items[i].style.saturation = 1.0;
		items[i].style.brightness = 1.0;
	}

    var itemTimers = itemGrid.FindChildrenWithClassTraverse('NeutralItemsTierTimes');

	var creepsLevel = ["5", "15-20", "25-40", "60", "100"];

	for(var i = 0; i < itemTimers.length; i++)
	{
		itemTimers[i].text = "Creeps Level: " + creepsLevel[i];
	}
}

function OnServerPrint(data)
{
	let msg = data.print_value
	let isError = data.is_error
	
	if ( msg == undefined || isError == undefined )
		return;
	
	if( isError )
		$.Msg("Exception: ", msg)
	else
		$.Msg("Print: ", msg)
}

(function()
{
	GameEvents.Subscribe( "DebugMessage", DebugPrintData)
	GameEvents.Subscribe( "MakeNeutralItemsInShopColored", MakeNeutralItemsInShopColored)
	GameEvents.Subscribe( "AADebugPrintMessage", OnServerPrint)
})();


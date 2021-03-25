"use strict";

var DUEL_CANT_PICK_PERIOD = 10; // TODO: Take it from server

var g_hero_data = undefined;
var g_tick = undefined;
var g_bCanPick = undefined;
var g_timerTime = 100 // TODO: From server

var RootPanel 			 = $.GetContextPanel();
var CustomRoot			 = RootPanel.FindChildTraverse("CustomRoot");
var MainRepickMenu 		 = RootPanel.FindChildTraverse("MainRepickMenu");
var PreviewPanel 		 = RootPanel.FindChildTraverse("Preview");
var PreviewHolder 		 = RootPanel.FindChildTraverse("PreviewHolder");
var HeroName 			 = RootPanel.FindChildTraverse("HeroName");
var HeroBlockHolder	 	 = RootPanel.FindChildTraverse("HeroBlockHolder");
var HeroesPanel 		 = RootPanel.FindChildTraverse("HeroBlock");
var HeroAbilities 		 = RootPanel.FindChildTraverse("HeroAbilities");

var AttStrengthLabel	 = RootPanel.FindChildTraverse("AttStrengthLabel");
var AttAgilityLabel	 	 = RootPanel.FindChildTraverse("AttAgilityLabel");
var AttIntellectLabel	 = RootPanel.FindChildTraverse("AttIntellectLabel");
var MovespeedLabel	 	 = RootPanel.FindChildTraverse("MovespeedLabel");
var DamageLabel	 	 	 = RootPanel.FindChildTraverse("DamageLabel");
var BaseAttackTimeLabel	 = RootPanel.FindChildTraverse("BaseAttackTimeLabel");
var ArmorLabel	 		 = RootPanel.FindChildTraverse("ArmorLabel");
var HealthStatus	 	 = RootPanel.FindChildTraverse("HealthStatus");
var HealthRegen	 		 = RootPanel.FindChildTraverse("HealthRegen");
var ManaStatus	 		 = RootPanel.FindChildTraverse("ManaStatus");
var ManaRegen	 		 = RootPanel.FindChildTraverse("ManaRegen");

var StrAttrImage 		 = RootPanel.FindChildTraverse("AttStrengthImage");
var AgiAttrImage 		 = RootPanel.FindChildTraverse("AttAgilityImage");
var IntAttrImage 		 = RootPanel.FindChildTraverse("AttIntellectImage");

var PickButton 		 	 = RootPanel.FindChildTraverse("PickButton");
var PickButtonLabel		 = PickButton.FindChildTraverse("PickButtonLabel");
var PickShard		 	 = PickButton.FindChildTraverse("PickShard");

var CurrentMainAttributePanel = undefined
var CurrentSelectedPanel = undefined
var SelectedHeroName = undefined

function HasShard(heroName)
{
	var playerID = Players.GetLocalPlayer();
	
	if( playerID == undefined || playerID < 0 )
		return false;
	
	var heroEntIndex = Players.GetPlayerHeroEntityIndex(playerID);
	
	if( heroEntIndex == -1 )
		return false;
	
	var item_name = g_hero_data[heroName]['item_name'];
	
	return Entities.HasItemInInventory( heroEntIndex, item_name );
}

// negative value - time for duel end, positive - time for duel start
function GetTimeForDuel()
{
	return g_timerTime;
}

var PickState = {
	CAN_PICK : 1,
	ALREADY_PICKED : -1,
	NO_SHARD : -2,
	DUEL_SOON : -3,
}

function CanPick(heroName)
{
	if( g_hero_data[heroName]['picked'] == 1 )
		return PickState.ALREADY_PICKED;
	
	if( !HasShard(heroName) )
		return PickState.NO_SHARD;
	
	if( GetTimeForDuel() < DUEL_CANT_PICK_PERIOD )
		return PickState.DUEL_SOON;
	
	return PickState.CAN_PICK;
}

function ActivatePickButton()
{
	if( g_bCanPick == true )
		return;
	
	PickButton.RemoveClass("CantPickButton");
	PickButton.AddClass("CanPickButton");
	
	PickButtonLabel.text = $.Localize("#AA_REPICK_MENU_PICK_GOD");
	
	g_bCanPick = true;
}

function DeactivePickButton(nReason)
{
	var text = "unknown";
	
	switch(nReason)
	{
		case PickState.CAN_PICK:
			text="<invalid_state>";
			break;
		case PickState.ALREADY_PICKED:
			text="#AA_REPICK_MENU_ALREADY_PICKED";
			break;
		case PickState.NO_SHARD:
			text="#AA_REPICK_MENU_NO_SHARD";
			break;
		case PickState.DUEL_SOON:
			text="#AA_REPICK_MENU_DUEL_SOON";
			break;
	}
	
	PickButtonLabel.text = $.Localize( text )
	PickButton.RemoveClass("CanPickButton");
	
	PickButton.AddClass("CantPickButton");
	
	g_bCanPick = false;
}

function Tick()
{
	if( SelectedHeroName != undefined )
	{
		var canPick = CanPick(SelectedHeroName);
		
		if( canPick == PickState.CAN_PICK )
			ActivatePickButton()
		else
			DeactivePickButton( canPick );
	}
	
	g_tick = $.Schedule(1.0, Tick);
}

function CancelTick()
{
	if( g_tick != undefined )
	{
		$.CancelScheduled( g_tick, {} );
		g_tick = undefined;
	}
}

function UpdateHeroesInterface()
{
	var childrens = HeroesPanel.Children();
	
	CurrentMainAttributePanel 	= undefined
	CurrentSelectedPanel 		= undefined
	SelectedHeroName 			= undefined
	
	HeroesPanel.RemoveAndDeleteChildren()
	
	HeroesPanel = $.CreatePanel("Panel", HeroBlockHolder, "HeroBlock");
	HeroesPanel.BLoadLayoutFromString(  '<root><Panel/></root>', true, true );
		
	var firstHero = undefined
	
	for (var hero_name in g_hero_data)
	{
		AddHeroIcon(hero_name)
		
		if (firstHero === undefined)
			firstHero = hero_name
	}
	
	if( firstHero === undefined )
		return;
	
	SelectHero(firstHero)
}

function OnOpen()
{
	UpdateHeroesInterface()
	
	CustomRoot.hittest = true
	CustomRoot.visible = true
	CustomRoot.enable = true
	CustomRoot.style.visibility = "visible";
	
	Tick();
}

function OnClose()
{
	CustomRoot.hittest = false
	CustomRoot.visible = false
	CustomRoot.enable = false
	CustomRoot.style.visibility = "collapse";
	
	CancelTick();
}

function GetHeroID(heroName)
{
	return CurrentSelectedPanel.Children()[0].heroid;
}

function SetAbilities(abilityTable, heroName)
{
	let layoutString = '<root><Panel>';
	
	for( let idx in abilityTable )
	{
		let abilityName = abilityTable[idx];
						
		// hate this JS formatting with ` symbols
		layoutString +=  '<DOTAAbilityImage ' +
						 'class="AbilityImage" ' + 
						 `abilityname="${abilityName}" ` +
						 'hittest="true" ' +
						 `onmouseover="DOTAShowAbilityTooltip(\'${abilityName}\')" ` +
						 'onmouseout="DOTAHideAbilityTooltip()" ' +
						 '/>';
	}

	let heroID = GetHeroID(heroName);
	
	layoutString += '<DOTATalentDisplay id="TalentTree" class="AbilityImage" ' + 
					`heroname="${heroName}" ` +
					`onmouseover="DOTAHUDShowHeroStatBranchTooltip (${heroID})" ` +
					'onmouseout="DOTAHUDHideStatBranchTooltip()" ' +
					'/>';
					
	layoutString += '</Panel></root>';
	
	HeroAbilities.BLoadLayoutFromString( layoutString, true, true );	
	
	let tree_parts = HeroAbilities.FindChildrenWithClassTraverse("StatBranchPip")
	
	tree_parts.forEach(panel=>{
		// ITS A HACK TO HIDE SELECTED HERO TALENTS
		panel.style.width = "0px"
		panel.style.height = "0px"
	})
}

function SetShardInfo(heroInfo)
{
	var itemName = heroInfo['item_name']
	var layoutString =  '<root><Panel ' +
						` style="background-image: url('s2r://panorama/images/custom_game/repick_menu/${itemName}.png');" ` +
						` onmouseover="DOTAShowAbilityTooltip(\'${itemName}\')" ` +
						' onmouseout="DOTAHideAbilityTooltip()" ' +
						'/></root>';
	
	PickShard.BLoadLayoutFromString( layoutString, true, true );
}

function SelectHero(heroName)
{
	// First, create hero preview
	
	// hate this JS formatting with ` symbols
	var layoutString =  '<root><Panel>' +
						'<DOTAScenePanel ' +
						'id="Preview" class="SceneLoaded" ' +
						`unit="${heroName}" ` + 
						'particleonly="false" ' +
						'hittest="true" ' +
						'allowrotation="true"/>' +
						'</Panel></root>';
	
	if( PreviewPanel != undefined )
	{
		PreviewPanel.visible = false;
		PreviewPanel.DeleteAsync(0);
	}
	
	PreviewPanel = $.CreatePanel("Panel", PreviewHolder, "Preview");
	PreviewPanel.BLoadLayoutFromString( layoutString, true, true );
		
	if( CurrentSelectedPanel != undefined )
		CurrentSelectedPanel.RemoveClass("HeroPortraitSelected");
	
	CurrentSelectedPanel = HeroesPanel.FindChildTraverse(heroName)
	CurrentSelectedPanel.AddClass("HeroPortraitSelected")
	
	// Second, fill hero stats info
	var hero_info = g_hero_data[heroName]
	
	HeroName.text = $.Localize(heroName)	
	SetAbilities(hero_info['abilities'], heroName)
	
	AttStrengthLabel.SetDialogVariable("base_str", hero_info['str'])
	AttStrengthLabel.SetDialogVariable("str_per_level", hero_info['str_gain'].toPrecision(2))
	
	AttAgilityLabel.SetDialogVariable("base_agi", hero_info['agi'])
	AttAgilityLabel.SetDialogVariable("agi_per_level", hero_info['agi_gain'].toPrecision(2))
	
	AttIntellectLabel.SetDialogVariable("base_int", hero_info['int'])
	AttIntellectLabel.SetDialogVariable("int_per_level", hero_info['int_gain'].toPrecision(2))
	
	DamageLabel.text 			= hero_info["dmg_min"] + " - " + hero_info["dmg_max"]
	
	BaseAttackTimeLabel.text 	= hero_info["bat"].toPrecision(2)
	MovespeedLabel.text 		= hero_info["movespeed"]
	ArmorLabel.text 			= hero_info["armor"].toPrecision(1)
	
	HealthStatus.text 			= hero_info["hp"].toFixed(0)
	ManaStatus.text 			= hero_info["mp"].toFixed(0)
	
	HealthRegen.text 			= " + " + hero_info["hp_reg"].toFixed(1)
	ManaRegen.text 				= " + " + hero_info["mp_reg"].toFixed(1)
	
	var curAttr = hero_info['base_att']
	
	if( CurrentMainAttributePanel != undefined )
		CurrentMainAttributePanel.RemoveClass("MainAttributeImage")

	switch( curAttr )
	{
		case Attributes.DOTA_ATTRIBUTE_STRENGTH:
			CurrentMainAttributePanel = StrAttrImage
			break;
		case Attributes.DOTA_ATTRIBUTE_AGILITY:
			CurrentMainAttributePanel = AgiAttrImage
			break;
		case Attributes.DOTA_ATTRIBUTE_INTELLECT:
			CurrentMainAttributePanel = IntAttrImage
			break;
	}
	
	if( CurrentMainAttributePanel != undefined )
		CurrentMainAttributePanel.AddClass("MainAttributeImage")
	
	SelectedHeroName = heroName
	
	SetShardInfo( hero_info )
	
	PickButton.visible = true
	Game.EmitSound("ui_select_md")
	
	CancelTick();
	Tick();
}


function AddHeroIcon(heroName)
{
	// hate this JS formatting with ` symbols
	var layoutString =  '<root><Panel class="HeroPortrait">' +
						'<DOTAHeroMovie '+
						'style="width:100%;height:100%;" ' + 
						`heroname="${heroName}" ` +
						`onactivate="SelectHero(\'${heroName}\');" ` +
						'hittest="true" ' +
						'/>"' +
						'</Panel></root>';
						
	var hero_panel = $.CreatePanel("Panel", HeroesPanel, heroName);
	hero_panel.BLoadLayoutFromString( layoutString, true, true );
}

function FillHeroesData(data)
{
	g_hero_data = data;
	
	UpdateHeroesInterface()
}

function PickHero()
{
	var canPick = CanPick( SelectedHeroName ) == PickState.CAN_PICK;
	
	if (!canPick)
		return;
	
	OnHeroPicked(SelectedHeroName)
	
	GameEvents.SendCustomGameEventToServer("aa_repick_menu_start_repick", { hero_name : SelectedHeroName } ); 
}

function OnHeroPicked(heroName, val)
{
	if( g_hero_data[heroName] != undefined )
		g_hero_data[heroName]['picked'] = val;
}

(function() 
{
	OnClose()
		
	GameEvents.Subscribe( "aa_repick_menu_set_data", FillHeroesData)
	
	GameEvents.Subscribe( "aa_repick_menu_open", function(data)
	{
		OnOpen()
	})
	
	GameEvents.Subscribe( "aa_repick_menu_close", function(data)
	{
		OnClose()
	})
	
	GameEvents.Subscribe( "aa_repick_menu_set_hero_picked", function(data) 
	{
		OnHeroPicked(data['hero_name'], data['picked'] );
	})
	
	CustomNetTables.SubscribeNetTableListener( "game_info", function()
	{
		//var data = CustomNetTables.GetTableValue( "game_info", "timer" )
		//g_timerTime = data['time']
		// TODO: Enable/disable when message from server
	})	
	
	GameEvents.SendCustomGameEventToServer("aa_repick_menu_retrive_data", {} ); 
})
()
var ARENA_STAGE_PICK = 1
var ARENA_STAGE_BAN = 0
var DOTA_TEAM_GOODGUYS = 2
var DOTA_TEAM_BADGUYS = 3
var BUTTON_CAPTAIN = 0
var BUTTON_BAN = 1 
var BUTTON_SELECT = 2 
var BUTTON_PICK = 3 
var END_STAGE = 23

var is_first
var init_counter = 0

var radiant_captain = -1 
var dire_captain = -1

var g_pregame
var g_container

var g_captain_button
var g_ban_button
var g_pick_button
var g_select_button

var g_start_game_button
var g_timer 
var g_stage 
var g_selected_hero = "npc_dota_hero_abaddon"
var g_now_stage 

var g_banned_heroes = {}
var g_selected_heroes = {}
var g_picked_heroes = {}
var is_ban_active = false 
var is_select_active = false 
var is_pick_active = false 

function OnStateChangedGame(args)
{
	if(Game.GetState() >= 7)
	{
		try 
		{
			if(g_container)
				g_container.RemoveAndDeleteChildren()
		}
		catch (err) {}
	}
}
		
function BecomeCaptain()
{
	var data = {
		playerID: Game.GetLocalPlayerID(), 
	}
	$.Msg("become captain")
	GameEvents.SendCustomGameEventToServer("cm_captain_selected", data ); 
}

function CaptainSelected( data )
{
	var cap_id = data.captain_id
	var team_id = data.team
	var self_team = Players.GetTeam(Game.GetLocalPlayerID())
	//$.Msg("new captain id = ", cap_id, " for team = ", team_id)
	
	var captain_name
	
	if(!g_container)
	{
		$.Msg("g_container is null")
		return;
	}
	
	if(team_id == 2)
	{
		if(radiant_captain != -1)
		{
			//$.Msg("captain already set")
			return;
		}
		
		captain_name = GetRequirePanel("RadiantCaptain")
		radiant_captain = cap_id
	}
	
	if(team_id == 3)
	{
		if(dire_captain != -1)
		{
			$.Msg("captain already set")
			return;
		}
		
		captain_name = GetRequirePanel("DireCaptain")
		dire_captain = cap_id
	}
	
	if(team_id == self_team)
	{
		if(g_captain_button)
		{
			SetInvisible(g_captain_button)
		}
	}
	
	if(captain_name)
		captain_name.text = "CAPTAIN:\n" + Players.GetPlayerName(cap_id)
	
	var player_team = Players.GetTeam(Game.GetLocalPlayerID())
}

function OnHeroActivate(hero_name)
{
	$.Msg("onheroactivate = ", hero_name, " stage =",g_stage)
	if(g_stage < 1)
		return 
	$.Msg("onheroactivate = ", hero_name, " stage =",g_stage)
	
	g_selected_hero = hero_name 
	
	if(g_ban_button && g_ban_button != null)
	{
		$.Msg("presetbuttonhero")
		var pick_text_panel = g_ban_button.FindChildTraverse("BanHeroText")
		SetButtonHero(pick_text_panel, "#DOTA_Hero_Selection_BanTitle", hero_name)
		if(is_ban_active)
		{
			if (!CanBeSelected(hero_name))
				SetInvisible(pick_text_panel.GetParent())
			else 
			{
				SetVisible(pick_text_panel.GetParent())
			}
		}
	}
	else 
		$.Msg("g_ban_button fail")
	
	if(g_pick_button)
	{
		var pick_text_panel = g_pick_button.FindChildTraverse("PickHeroText")
		SetButtonHero(pick_text_panel, "#DOTA_Hero_Selection_LOCKIN", hero_name)
		if(g_stage >= END_STAGE && CanBePicked(hero_name, Players.GetTeam(Game.GetLocalPlayerID())) ) 
		{
			SetVisible(pick_text_panel.GetParent())
		}
		else 
		{
			SetInvisible(pick_text_panel.GetParent())
		}
	}
	else 
		$.Msg("g_pick_button fail in onheroactivate")

	if(g_select_button)
	{
		var pick_text_panel = g_select_button.FindChildTraverse("SelectHeroText")
		SetButtonHero(pick_text_panel, "#DOTA_Hero_Selection_LOCKIN", hero_name)
		if(is_select_active)
		{
			if (!CanBeSelected(hero_name))
				SetInvisible(pick_text_panel.GetParent())
			else 
				SetVisible(pick_text_panel.GetParent())
		}
	}
	else 
		$.Msg("g_select_button fail in onheroactivate")
}

function SetButtonHero(panelButton, text, hero_name)
{
	//$.Msg("Set button hero ", text, hero_name, panelButton)
	if(panelButton)
	{
		panelButton.text = $.Localize(text) + " " + $.Localize(hero_name)
		
		panelParent= panelButton.GetParent()
		
		panelButton.FindChildTraverse(panelButton.id + "Icon")
		
		var icon = panelButton.icon
		
		
		try {
			if(icon)
			{
				icon.visible = false;
				icon.DeleteAsync(0);
				panelButton.icon = null 
			}
		}
		catch(err){}
		
		
		icon = $.CreatePanel("DOTAHeroImage", panelButton.GetParent(), panelButton.id + "_icon");
		icon.heroimagestyle = "landscape"
		icon.AddClass("HeroIconFree")
		icon.heroname = hero_name
		panelButton.icon = icon 
	}
	else 
		$.Msg("FAILED")
}

function IsCaptain()
{
	var table = CustomNetTables.GetTableValue( "captains_mode", "team_captains" )
	
	if(table)
	{
		if(table["" + Players.GetTeam(Game.GetLocalPlayerID())] == Game.GetLocalPlayerID() )
		{
			$.Msg("IS CAPTAIN = ", Game.GetLocalPlayerID(), " tbl:", table["" + Players.GetTeam(Game.GetLocalPlayerID())] == Game.GetLocalPlayerID(), " :", Players.GetTeam(Game.GetLocalPlayerID()))
			return true 
		}
		else 
		{
			return false
		}
	}
	
	return flase
	
}

/*
	BUTTON_CAPTAIN
	BUTTON_BAN 
	BUTTON_SELECT
	BUTTON_PICK*/
function SetButton(bt_type, active)
{
	var button
	
	if(bt_type == BUTTON_CAPTAIN)
		button = g_captain_button
	
	if(bt_type == BUTTON_BAN)
	{
		button = g_ban_button
		
		if(active == true )
			is_ban_active = true
		else 
			is_ban_active = false 
		
	}
	else
	{
		is_ban_active = false 
	}
	
	if(bt_type == BUTTON_SELECT)
	{
		button = g_select_button
		if(active == true)
			is_select_active = true 
		else 
			is_select_active = false 
	}
	else
	{	
		is_select_active = false 
	}
	
	if(bt_type == BUTTON_PICK)
	{
		if(active == true)
			is_pick_active = true 
		else 
			is_pick_active = false 
		
		button = g_pick_button
	}
	else 
	{
		is_pick_active = false 
	}
	
	if(!button)
	{
		$.Msg("[CM] Failed to set button " , bt_type, " to state " , active , " caused by button is null")
	}
	
	if(active)
	{
		SetVisible(button)
		OnHeroActivate(g_selected_hero)
	}
	else 
		SetInvisible(button)
}

function SetActiveSlot(team, stage, slot)
{
	var panel_name = ""
	var class_name = ""
	
	if(team == DOTA_TEAM_GOODGUYS)
		panel_name += "Radiant"

	if(team == DOTA_TEAM_BADGUYS) 
		panel_name += "Dire"
	
	if(stage == ARENA_STAGE_BAN)
	{
		panel_name += "Ban"
		class_name = "NowStageBan"
	}
	
	if(stage == ARENA_STAGE_PICK)
	{
		panel_name += "Pick"
		class_name = "NowStagePick"
	}
	
	panel_name += slot; 
	
	if(g_now_stage)
	{
		g_now_stage.RemoveClass("NowStageBan")
		g_now_stage.RemoveClass("NowStagePick")
	}
	
	g_now_stage = GetRequirePanel(panel_name)
	
	if(g_now_stage)
	{
		g_now_stage.AddClass(class_name)
	}
}


function CMOnStageChanges( data )
{
	g_stage = data.stage
}

function SetVisible(panel)
{
	if(panel)
	{
		panel.style.opacity = "1.0"
		panel.visible = true
	}
}

function SetInvisible(panel)
{
	if(panel)
	{
		panel.style.opacity = "0.0"
		panel.visible = false
	}
}

function GetRequirePanel(name)
{
	if(!g_container)
	{
		var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
		var container = dotaHud.FindChildTraverse("CaptainsModeMainPanel")
		g_container = container
	}
	if(!g_container)
		return null;

	var pnl = g_container.FindChildTraverse(name)
	return pnl
}

function CMOnTimerThinks( data )
{
	
	if(!g_timer)
	{
		var pregame = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent()
		if(pregame)
		{
			g_timer = pregame.FindChildTraverse("ClockLabel")
		}
		
		return;
	}
	g_timer.text = data.time
}

function FixResolutions()
{
	$.Schedule(1, FixResolutions)
	if(!g_container)
	{
		return
	}
	var mult = Game.GetScreenWidth() / Game.GetScreenHeight()
	
	//$.Msg("fixing resol ", Game.GetScreenWidth(),"x", Game.GetScreenHeight(), "=", mult)
	
	if (mult == 4/3 || mult == 1280/1024)
		Fix4x3()
	else 
		Fix16x9()
		
}

function Fix16x9()
{
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("RadiantPick" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon4x3")
			tempPanel.AddClass("HeroIcon")
		}
	}
	
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("DirePick" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon4x3")
			tempPanel.AddClass("HeroIcon")
		}
	}
		
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("RadiantBan" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon4x3")
			tempPanel.AddClass("HeroIcon")
		}
	}
	
	for(var i = 1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("DireBan" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon4x3")
			tempPanel.AddClass("HeroIcon")
		}
	}
	
	
}

function Fix4x3()
{
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("RadiantPick" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon")
			tempPanel.AddClass("HeroIcon4x3")
		}
	}
	
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("DirePick" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon")
			tempPanel.AddClass("HeroIcon4x3")
		}
	}
		
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("RadiantBan" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon")
			tempPanel.AddClass("HeroIcon4x3")
		}
	}
	
	for(var i =1; i <= 5;i++)
	{
		var tempPanel = g_container.FindChildTraverse("DireBan" + i)
		if(tempPanel)
		{
			tempPanel.RemoveClass("HeroIcon")
			tempPanel.AddClass("HeroIcon4x3")
		}
	}
}


function SelectHero()
{
	var playerid = Game.GetLocalPlayerID()
	var data = {
		hero_name: g_selected_hero,
		playerid: playerid,
	}
	
	GameEvents.SendCustomGameEventToServer("cm_selected", data ); 
	
}

function SetSelectedHero(hero_name, team, slot)
{
	if(!g_container || g_container == null) 
	{
		$.Msg("FAILED g_container!")
	}
	if(!slot)
	{
		$.Msg("SetSelectedHero slot is invalid")
	}
	
	try 
	{
		var place
		
		if(team == 2)
		{			
			place = g_container.FindChildTraverse("RadiantPick" + slot)
		}
		if(team == 3) 
		{
			place = g_container.FindChildTraverse("DirePick" + slot)
		}
		
		if(place)
		{
			var icon = $.CreatePanel("DOTAHeroImage", place, place.id + "_icon");
			icon.heroimagestyle = "landscape"
			icon.AddClass("HeroIconFree")
			icon.heroname = hero_name
			icon.SetPanelEvent( 'onactivate', (function() { return function() { 	OnHeroActivate(hero_name) 	} }() 	) )
															
			var hero_icon = g_container.FindChildTraverse(hero_name)
		
			if(hero_icon)
				hero_icon.AddClass("HeroIconSmallDisabled")
			else 
				$.Msg("fail find")
		}
	}
	catch (err)
	{
		$.Msg("error = ", err)
	}
}

function SetBannedHero(hero_name, team, slot)
{
	if(!g_container) 
	{
		$.Msg("FAILED g_container SetBannedHero!")
	}
	
	var place
	
	if(team == 2) 
	{
		if(g_container && g_container != null)
			place = g_container.FindChildTraverse("RadiantBan" + slot)
		else 
			$.Msg("fails et banned hero, failed g_container")
	}
	if(team == 3) 
	{
		if(g_container && g_container != null)
			place = g_container.FindChildTraverse("DireBan" + slot)
		else 
			$.Msg("fails et banned hero, failed g_container")
	}
	
	if(place)
	{
		if(hero_name != "none")
		{
			var icon = $.CreatePanel("DOTAHeroImage", place, place.id + "_icon");
			icon.heroimagestyle = "landscape"
			icon.AddClass("HeroIconFree")
			icon.heroname = hero_name
			
			var hero_icon = g_container.FindChildTraverse(hero_name)
		
			if(hero_icon)
				hero_icon.AddClass("HeroIconSmallDisabled")
			else 
				$.Msg("fail find")
		}		
		var img = $.CreatePanel("Image", place, place.id + "_img");
		img.SetImage("s2r://panorama/images/banned_overlay_psd.vtex")
		img.AddClass("HeroIconFree")		
		img.AddClass("BlockedHero")
	}
}

// callback for ban button
function BanHeroFromLua(data)
{
	var team = data.team 
	var hero_name = data.hero_name 
	
	var team = data.team 
	var hero_name = data.hero_name 
	var slot = data.slot

	if(slot == 0) 
		$.Msg("ERROR ERROR INVALID SLOT BAN, slot = ", slot)

	g_banned_heroes[hero_name] = team 
	
	SetBannedHero(hero_name, team, slot)
	//$.Msg("Ban lua hero for team hero:", hero_name, " team:", team, " slot:", slot)
}

function CanBeSelected(hero_name)
{
	if(g_selected_heroes[hero_name] || g_banned_heroes[hero_name])
		return false 
	
	return true 
}


function CanBePicked(hero_name, team)
{
	if(!hero_name)
	{
		$.Msg("invalid hero name")
		return false 
	}
	
	if(g_picked_heroes[hero_name])
	{
		$.Msg("hero already picked")
		return false 
	}
	
	var player_id = Game.GetLocalPlayerID()
	var player_team = Players.GetTeam(player_id)
	var new_table = CustomNetTables.GetTableValue( "captains_mode", "selected_heroes" )
	if(player_team == 2)
		new_table = new_table["radiant_picks"]
	if(player_team == 3)
		new_table = new_table["dire_picks"]
	
	if(new_table)
	{
		if(new_table[hero_name])
			return true
		else 
		{
			$.Msg("not such hero in table = ", g_picked_heroes[hero_name], " hero_name = ", hero_name)
		}
	}
	else 
	{
		$.Msg("TABLE IS NIL new_table")
	}

	return false 
}

// callback for pick button
function SelectHeroFromLua(data)
{
	var team = data.team 
	var hero_name = data.hero_name
	var slot = data.slot 

	if(slot == 0) 
		$.Msg("ERROR ERROR INVALID SLOT, stage = ")
	
	g_selected_heroes[hero_name] = team 
	
	SetSelectedHero(hero_name, team, slot)
}

function OnHeroPicked(data)
{
	var team = data.team 
	var hero_name = data.hero_name 
	var player_id = data.playerid
	//OnHeroActivate(hero_name)
	if (player_id == Game.GetLocalPlayerID())
	{
		SetInvisible(g_pick_button)
		g_pick_button.DeleteAsync(0)
		g_pick_button = null
		g_ban_button.DeleteAsync(0)
		g_ban_button = null
		g_select_button.DeleteAsync(0)
		g_select_button = null
	}
	
	if (hero_name == g_selected_hero)
	{
		SetInvisible(g_pick_button)
	}
}

function Sync()
{
	$.Msg("[CM] Sync ...")
	if(Game.GetState() <= 7)
	{
		//$.Schedule(5, Sync)
	}
	
	
	if(!g_container)
	{
		var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
		var container = dotaHud.FindChildTraverse("CaptainsModeMainPanel")
		if(container)
		{
			g_ban_button = container.FindChildTraverse("BanHero")
			g_pick_button = container.FindChildTraverse("PickHero")
			g_select_button = container.FindChildTraverse("SelectHero")
			g_captain_button = container.FindChildTraverse("BecomeCaptain")
		}
	}
	
	var table = CustomNetTables.GetTableValue( "captains_mode", "stage" )
	if(table)
	{
		CMOnStageChanges( { stage: table.stage } )
	}
	else 
	{
		//$.Msg("[SYNC] Table stage is null")
	}

	table = CustomNetTables.GetTableValue( "captains_mode", "selected_heroes" )
	if(table)
	{
		for(var selected in table["radiant_picks"])
		{
			var data = {
				team: 2,
				hero_name: selected,
				slot: table["radiant_picks"][selected],
			}
			SelectHeroFromLua(data)
			//$.Msg("Select hero from lua sync = ", data)
		}
		
		for(var selected in table["dire_picks"])
		{
			var data = {
				team: 3,
				hero_name: selected,
				slot: table["dire_picks"][selected],
			}
			SelectHeroFromLua(data)
			//$.Msg("Select hero from lua sync = ", data)
		}
	}
	else 
	{
		//$.Msg("[SYNC] Table selected heroes is null")
	}

	table = CustomNetTables.GetTableValue( "captains_mode", "banned_heroes" )
	if(table)
	{
		for(var banned in table["radiant_bans"])
		{
			var data = {
				team: 2,
				hero_name: banned,
				slot: table["radiant_bans"][banned],
			}
			BanHeroFromLua(data)
			//$.Msg("Ban hero from lua sync = ", data)
		}
		
		for(var banned in table["dire_bans"])
		{
			var data = {
				team: 3,
				hero_name: banned,
				slot: table["dire_bans"][banned],
			}
			BanHeroFromLua(data)
			//$.Msg("Ban hero from lua sync = ", data)
		}
	}	
	else 
	{
		//$.Msg("[SYNC] Banned heroes in null")
	}
		
	table = CustomNetTables.GetTableValue( "captains_mode", "team_captains" )
	if(table)
	{	
		if(table[2] != -1)
		{
			CaptainSelected( {captain_id:table[2], team:2} )
		}
		else 
		{
			//$.Msg("invalid captain for team 2, captain = ", table[2])
		}

		if(table[3] != -1)
		{
			CaptainSelected( {captain_id:table[3], team:3} )
		}
		else 
		{
			//$.Msg("invalid captain for team 3, captain = ", table[3])
		}
	}
	else 
	{
		//$.Msg("[SYNC] CAPTAIN TABLE INVALID")
	}
}

function SetStage(data)
{
	//function SetButton(bt_type, active)
	//function SetActiveSlot(team, stage, slot)
	var stage = data.stage_id
	var slot = data.slot 
	var team = data.team 
	
	if(stage != null && slot != null && team != null)
	{
		SetActiveSlot(team, stage, slot)
	}
	else 
	{
		$.Msg("SetStage error, some data is null", data )
	}
}

function SetStageButton(data)
{
	var bt_type = data.bt_type 
	var active = data.active 
	
	if(bt_type != null && active != null)
	{
		SetButton(bt_type, active)
	}
	else 
	{
		$.Msg("SetStageButton error, some data is null ", data )
	}
}

function LoadContainer()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	var container = dotaHud.FindChildTraverse("CaptainsModeMainPanel")
	
	if(container)
	{
		g_container = container
		g_ban_button = container.FindChildTraverse("BanHero")
		g_pick_button = container.FindChildTraverse("PickHero")
		g_select_button = container.FindChildTraverse("SelectHero")
		g_captain_button = container.FindChildTraverse("BecomeCaptain")
		Sync()
	}
	else 
	{
		$.Schedule(1, LoadContainer)
	}
}

(function()
{
	$.Msg("initilizing")
	OnStateChangedGame()
	GameEvents.Subscribe("game_rules_state_change", OnStateChangedGame);
	GameEvents.Subscribe("cm_captain_select_accept", CaptainSelected)
	GameEvents.Subscribe("cm_captain_stage_changed", CMOnStageChanges)
	GameEvents.Subscribe("cm_captain_timer", CMOnTimerThinks)
	GameEvents.Subscribe("cm_picked", OnHeroPicked)
	
	// NEW REFACTORY 
	GameEvents.Subscribe("cm_set_stage", 		SetStage)
	GameEvents.Subscribe("cm_set_stage_button", SetStageButton)
	
	// OLD
	GameEvents.Subscribe("cm_captain_banned", BanHeroFromLua)
	GameEvents.Subscribe("cm_captain_selected_hero", SelectHeroFromLua)

	LoadContainer()
	
	$.Schedule(2, Sync)
	$.Schedule(2, FixResolutions)
	
})();

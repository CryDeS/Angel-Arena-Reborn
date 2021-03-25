var g_container
var g_timer 
var g_ban_button
var g_pick_button
var g_select_button
var g_captain_button
var init_counter

function OnStateChangedGame(args)
{
	if(Game.GetState() >= 3 && Game.GetState() < 7)
	{
		$.Schedule(0.2, _init)
	}
	
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

function _init()
{
	is_first = true;
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
    var pregame = dotaHud.FindChildTraverse("PreGame")
	
	if(pregame && pregame.style.opacity != "0.0") 
	{
		g_pregame = pregame 

		var container = pregame.FindChildTraverse("HeroPickLeftColumn")
		var right_container = pregame.FindChildTraverse("HeroPickRightColumn")
		var MainHeroPickScreenContents = pregame.FindChildTraverse("MainHeroPickScreenContents")
		
		// Try to catch onactivate 
			
		
		if (MainHeroPickScreenContents) 
		{
			MainHeroPickScreenContents.style.marginRight = "0px";
			MainHeroPickScreenContents.style.marginLeft = "0px";
			MainHeroPickScreenContents.style.marginTop = "-5%";
			MainHeroPickScreenContents.style.height = "95%"
		}
				
		if(container) 
		{
			if(right_container)
			{
				right_container.style.opacity = "0.0"
			}
			var new_container = $.CreatePanel("Panel", container.GetParent(), "new_container")
			
			g_container = container
			container.style.marginRight = "0px"
			container.style.width = "100%"
			
			var hero_grid = container.FindChildTraverse("HeroGrid")
			var hero_filters = container.FindChildTraverse("HeroFilters")
			
			if(hero_grid)
			{
				hero_grid.style.opacity = "0.0"
			}
			
			if(hero_filters)
			{
				hero_filters.style.opacity = "0.0"
			}
			container.style.width = "100%"
			container.flowChildren = "none"
			g_container =  new_container
			container = new_container 
			new_container.AddClass("AntiBugClass")
			new_container.enable = true 
			new_container.visible = true 
			new_container.AddClass("HeroPickLeftColumn")
			new_container.BLoadLayout("file://{resources}/layout/custom_game/captains_mode.xml", false, false);
			//container.BLoadLayout("file://{resources}/layout/custom_game/captains_mode.xml", false, false);
			//FixResolutions()
			
			g_ban_button = container.FindChildTraverse("BanHero")
			g_pick_button = container.FindChildTraverse("PickHero")
			g_select_button = container.FindChildTraverse("SelectHero")
			g_captain_button = container.FindChildTraverse("BecomeCaptain")
			
			if(g_captain_button)
				g_captain_button.style.opacity = "1.0"
			
			if(g_ban_button)
				g_ban_button.style.opacity = "0.0"
			
			if(g_pick_button)
				g_pick_button.style.opacity = "0.0"
		
			if(g_select_button)
				g_select_button.style.opacity = "0.0"
		
			g_timer = dotaHud.FindChildTraverse("ClockLabel")
		}
	}
	else 
	{
		
		if(init_counter > 10)
			return;
					
		init_counter++;
		$.Schedule(1, _init)
	}
		
}
(function()
{
	if (Game.GetMapInfo().map_display_name != "map_5x5_cm")
	{
		$.Msg("CM mode init failed, that not cm map!", Game.GetMapInfo())
		return 
	}
	
	GameEvents.Subscribe("game_rules_state_change", OnStateChangedGame);

	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	var container = dotaHud.FindChildTraverse("CaptainsModeMainPanel")
	if(!container)
	{
		OnStateChangedGame()
	}	
})();

"use strict";
//var list;
function bt_id( event ){
    $.Msg("[JS]button id:" + event) // вывод в консоль
    var plyID = Game.GetLocalPlayerID(); // Game - глобальная штука, смотри API JS

    var data = {		// Обьект для передачи в Луа
        playerID: plyID, 
		playerBt: event,
		list_number: $("#list_text").text
    }
    // кладем "придуманное_имя_события" и наш обьект
    GameEvents.SendCustomGameEventToServer("hc_menu_button_pressed", data ); 
	
	if (!(event == 9) && !(event == 10))
	{
		close_menu("1")
	}
	if (event == "11") 
	{
		close_menu("1")
	}
	if (event == "9")
	{
		var data = {		// Обьект для передачи в Луа
			playerID: plyID, 
			page: $("#list_text").text
		}
		$.Msg("[JS][LASTPAGE] curpage = " + data.page)
		GameEvents.SendCustomGameEventToServer("hero_last_page", data ); 
	} 
	if (event == "10")
	{
		var data = {		// Обьект для передачи в Луа
			playerID: plyID, 
			page: $("#list_text").text
		}
		$.Msg("[JS][NEXTPAGE] curpage = " + data.page)
		GameEvents.SendCustomGameEventToServer("hero_next_page", data ); 
	} 
}

function close_menu(event)
{
	/*$( "#CBlock" ).RemoveClass("visible")
	$( "#CBlock" ).AddClass("unvisible")*/
	$( "#CBlock").visible = false;
}

function open_menu(event) //ТЕСТИТЬ, БЛДЖД ВЛАД!
{
	$.Msg("[JS]Trying to open menu on page!")
	$( "#CBlock").visible = true;
	var list_number = event.list_number
	var hero_name = event.hero_numbers
	$.Msg(event.hero_numbers)
	var current_button_id;
	var cbg // current_background_image
	$("#list_text").text = list_number
	for (var i = 1; i < 9; i++) {
		if ( !hero_name[i] ) 
		{
			hero_name[i] = -1
		}
		current_button_id = "#bt_" + i + "_av";

		cbg = "file://{images}/custom_game/hero_change_interface/hero_av/hero_avat_" + hero_name[i] + ".png"
		//$( current_button_id ).style.backgroundImage = cbg
		$( current_button_id ).SetImage(cbg)
		//если кнопку убирали
		$( current_button_id ).visible = true
		current_button_id = "#bt_id" + i
		$( current_button_id ).visible = true
		
		if (hero_name[i] == "-1") //если нет имени героя, убираем кнопку нахуй
		{		
			current_button_id = "#bt_" + i + "_av";
			$( current_button_id ).visible = false
			current_button_id = "#bt_id" + i
			$( current_button_id ).visible = false
		}
		current_button_id = "#bt_" + i + "_text"
		$(current_button_id).text = $.Localize("#PN_" + hero_name[i] + "_text")
	}

}


(function()
{
	close_menu("0")
	GameEvents.Subscribe( "change_hero_menu_open", open_menu );
	GameEvents.Subscribe( "change_hero_menu_close", close_menu );
})();



function FormatSeconds(value, withHoures) {
	var theTime = parseInt(value);
	var theTime1 = 0;
	var theTime2 = 0;
	if (theTime > 60) {
		theTime1 = parseInt(theTime / 60);
		theTime = parseInt(theTime % 60);
		if (theTime1 > 60) {
			theTime2 = parseInt(theTime1 / 60);
			theTime1 = parseInt(theTime1 % 60);
		}
	}

	var result = "";

	if (theTime < 10) {
		result = "0" + parseInt(theTime);
	} else {
		result = "" + parseInt(theTime);
	}

	if (theTime1 < 10) {
		result = "0" + parseInt(theTime1) + ":" + result;
	} else {
		result = "" + parseInt(theTime1) + ":" + result;
	}
	if (withHoures) result = "" + parseInt(theTime2) + ":" + result;

	return result;
}

function GetHEXPlayerColor(player_id) {
	var player_color = Players.GetPlayerColor(player_id).toString(16);
	return player_color == null
		? "#000000"
		: "#" +
				player_color.substring(6, 8) +
				player_color.substring(4, 6) +
				player_color.substring(2, 4) +
				player_color.substring(0, 2);
}

require('lib/game_modes/normal_mode')
require('lib/game_modes/captains_mode')

local MAPPING = {
	['map_5x5']    = NormalMode,
	['map_5x5_cm'] = CaptainsMode,
}

function GetBaseGamemode()
	return MAPPING[ GetMapName() ]
end
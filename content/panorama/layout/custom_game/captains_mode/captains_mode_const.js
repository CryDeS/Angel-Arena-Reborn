const HERO_NO_STATE = 0;
const HERO_OFFER_BAN = 1;
const HERO_OFFER_PICK = 2;
const HERO_BANNED = 3;
const HERO_BLOCKED = 4;

const STATES_CLASSES = {
	[HERO_NO_STATE]: "",
	[HERO_OFFER_BAN]: "OfferBan",
	[HERO_OFFER_PICK]: "OfferPick",
	[HERO_BANNED]: "HeroBanned",
	[HERO_BLOCKED]: "HeroBlocked",
};

const HEROES_ROOTS = [$("#HeroesStrList"), $("#HeroesAgiList"), $("#HeroesIntList")];
const STAGES_ROOT = $("#StagesRoot");
const TOP_BAR_RADIENT_ROOT = $("#RadiantPlayers");
const TOP_BAR_DIRE_ROOT = $("#DirePlayers");
const STAGES_LINES = [
	[false, true],
	[false, true],
	[true, true],
	[true, true],
	[false, true],
	[false, true],
	[false, true],
	[true, false],
	[true, false],
	[false, true],
	[false, true],
	[true, true],
];
const CM_TIME_LABEL = $("#CM_Time");
const CM_DESCRIPTION_LABEL = $("#CM_Description");
const STAGE_CAPTAION_BUTTON = $("#StagesButton");
const STAGE_HERO_ICON_CAPTAIN = $("#StagesButton_Hero");
const STAGE_HERO_NAME_CAPTAIN = $("#StagesButton_HeroName");
const LOCAL_PLAYER_ID = Game.GetLocalPlayerID();
const LOCAL_TEAM = Players.GetTeam(LOCAL_PLAYER_ID);

const DOTA_TEAM_RADIANT = 2;
const DOTA_TEAM_DIRE = 3;

const ADDITIONAL_TIME_RADIANT = $("#AdditionalTimeRadiant_Value");
const ADDITIONAL_TIME_DIRE = $("#AdditionalTimeDire_Value");

const HERO_MOVIE_TOOLTIP_ROOT = $("#HeroCardMovieRoot");
const HERO_MOVIE_TOOLTIP_UNIT = $("#HeroCardMovie");
const HERO_MOVIE_TOOLTIP_NAME = $("#HeroMovieName");

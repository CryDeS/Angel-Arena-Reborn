let HEROES = {};
let BANS = {
	[DOTA_TEAM_DIRE]: [],
	[DOTA_TEAM_RADIANT]: [],
};
let PICKS = {
	[DOTA_TEAM_DIRE]: [],
	[DOTA_TEAM_RADIANT]: [],
};
let STAGES_BY_NUMBER = {};
let PLAYER_IN_TOP_BAR = {};
let STAGE = 1;
let LOCAL_IS_CAPTAIN = false;
let STAGES = [];

class HeroButton {
	constructor(hero_name, stat_id) {
		const panel = $.CreatePanel("Panel", HEROES_ROOTS[stat_id], hero_name);
		this.state = HERO_NO_STATE;
		this.panel = panel;
		panel.BLoadLayoutSnippet("HeroButton");
		const hero_icon = panel.FindChildTraverse("HeroImage");
		hero_icon.heroname = hero_name;
		panel.SetPanelEvent("onactivate", () => {
			if (LOCAL_IS_CAPTAIN) {
				STAGE_CAPTAION_BUTTON.SetHasClass("Show", true);
				const is_ally_stage = STAGES_BY_NUMBER[STAGE].team == LOCAL_TEAM;
				STAGE_CAPTAION_BUTTON.SetHasClass("Blocked", !is_ally_stage);
				STAGE_HERO_ICON_CAPTAIN.heroname = hero_name;
				STAGE_HERO_NAME_CAPTAIN.text = $.Localize(hero_name).toUpperCase();
				if (is_ally_stage) {
					const hero_icon_stage = STAGES_BY_NUMBER[STAGE].panel.GetChild(1);
					const is_select_stage = hero_icon_stage.GetParent().GetParent().BHasClass("SelectHero");
					STAGE_CAPTAION_BUTTON.SetHasClass("SelectStageCaptain", is_select_stage);
					STAGE_CAPTAION_BUTTON.SetHasClass("BanStageCaptain", !is_select_stage);
					hero_icon_stage.heroname = hero_name;
					hero_icon_stage.SetHasClass(is_select_stage ? "PreselectHeroStage" : "PrebanHeroStage", true);
				}
			}
		});

		panel.SetPanelEvent("onmouseover", () => {
			const pos = panel.GetPositionWithinWindow();
			HERO_MOVIE_TOOLTIP_ROOT.style.position = `${pos.x - 50}px ${pos.y - 60}px 0px`;
			HERO_MOVIE_TOOLTIP_ROOT.visible = true;
			HERO_MOVIE_TOOLTIP_UNIT.heroname = hero_name;
			HERO_MOVIE_TOOLTIP_NAME.text = $.Localize(hero_name).toUpperCase();
		});

		panel.SetPanelEvent("onmouseout", () => {
			HERO_MOVIE_TOOLTIP_ROOT.visible = false;
		});

		// const hero_movement_panel = panel.FindChildTraverse("HeroMovie");
		// hero_movement_panel.heroname = hero_name;
		// panel.SetPanelEvent("onmouseout", () => {
		// 	hero_movement_panel.visible = false;
		// });
		//
		// panel.SetPanelEvent("onmouseover", () => {
		// 	hero_movement_panel.visible = true;
		// });
	}
	SetState(state) {
		this.panel.RemoveClass(STATES_CLASSES[this.state]);
		this.state = state;
		this.panel.AddClass(STATES_CLASSES[this.state]);
	}
}

class Stage {
	constructor(stageInfo, pair_number) {
		const panel = $.CreatePanel("Panel", STAGES_ROOT, "");
		panel.BLoadLayoutSnippet("Stage");
		const is_pick_stage = stageInfo[0];
		const is_radiant_first = stageInfo[1];
		const dire_choose_root = panel.FindChildTraverse("DireChoose");
		const radiant_choose_root = panel.FindChildTraverse("RadiantChoose");

		panel.SetHasClass("SelectHero", is_pick_stage);
		panel.SetHasClass("RadiantFirst", is_radiant_first);
		const save_stage = function (panel_name, stage_number) {
			panel.FindChildTraverse(panel_name).text = stage_number;
			const team_flag = is_radiant_first ? stage_number % 2 : !(stage_number % 2);
			STAGES_BY_NUMBER[stage_number] = {
				panel: team_flag ? dire_choose_root : radiant_choose_root,
				team: team_flag ? DOTA_TEAM_DIRE : DOTA_TEAM_RADIANT,
			};
		};
		const counter = (pair_number + 1) * 2;
		save_stage("FirstStageNumber", counter - 1);
		save_stage("SecondStageNumber", counter);
		const save_data = is_pick_stage ? PICKS : BANS;
		save_data[DOTA_TEAM_DIRE].push(dire_choose_root);
		save_data[DOTA_TEAM_RADIANT].push(radiant_choose_root);

		this.radiant_choose_root = radiant_choose_root;
		this.dire_choose_root = dire_choose_root;
		this.root = panel;
	}
	ClearStyles() {
		const clear_panel_from_classes = function (panel, classes) {
			classes.forEach((class_name) => {
				panel.RemoveClass(class_name);
			});
		};
		clear_panel_from_classes(this.root, ["FirstNumberGlow", "SecondNumberGlow"]);
		clear_panel_from_classes(this.dire_choose_root, ["CurrentStageAlly", "CurrentStageEnemy"]);
		clear_panel_from_classes(this.radiant_choose_root, ["CurrentStageAlly", "CurrentStageEnemy"]);
	}
}
function CreateStages() {
	STAGES_ROOT.RemoveAndDeleteChildren();
	STAGES_LINES.forEach((stageInfo, index) => {
		STAGES.push(new Stage(stageInfo, index));
	});
}
function CreateHeroList(data) {
	Object.entries(data).forEach(([stat_id, heroes_list]) => {
		heroes_list.forEach((hero_name) => {
			HEROES[hero_name] = new HeroButton(hero_name, stat_id);
		});
	});
}

function CreateTopBar() {
	for (let player_id = 0; player_id <= 10; player_id++) {
		const player_info = Game.GetPlayerInfo(player_id);
		if (player_info != undefined) {
			const root_panel = Players.GetTeam(player_id) == 2 ? TOP_BAR_RADIENT_ROOT : TOP_BAR_DIRE_ROOT;
			const player_panel = $.CreatePanel("Panel", root_panel, `PlayerTopBar_${player_id}`);
			player_panel.BLoadLayoutSnippet("PlayerTopBar");
			player_panel.FindChildTraverse("PlayerName").steamid = player_info.player_steamid;
			// player_panel.FindChildTraverse("HeroTopBar").heroname = player_info.player_selected_hero;
			const player_color = GetHEXPlayerColor(player_id);
			player_panel.FindChildTraverse("PlayerColor").style.backgroundColor = player_color;
			PLAYER_IN_TOP_BAR[player_id] = player_panel;
		}
	}
}
function UpdateStage() {
	const is_ally_stage = LOCAL_TEAM == STAGES_BY_NUMBER[STAGE].team;
	STAGES.forEach((stage) => stage.ClearStyles());
	STAGES_BY_NUMBER[STAGE].panel
		.GetParent()
		.SetHasClass(STAGE % 2 == 1 ? "FirstNumberGlow" : "SecondNumberGlow", true);
	STAGES_BY_NUMBER[STAGE].panel.SetHasClass(is_ally_stage ? "CurrentStageAlly" : "CurrentStageEnemy", true);
}
function UpdateTimerText(value, is_addition_time) {
	let time_panel = CM_TIME_LABEL;
	if (is_addition_time) {
		time_panel = STAGES_BY_NUMBER[STAGE] == 2 ? ADDITIONAL_TIME_RADIANT : ADDITIONAL_TIME_DIRE;
	}
	time_panel.text = FormatSeconds(value, false);
}
function UpdateInfo(data) {
	UpdateTimerText(data.time, false);
	const update_info_from_data = function (table, team) {};
	data.bannedHeroes[DOTA_TEAM_RADIANT].forEach((hero_name, index) => {
		BANS[DOTA_TEAM_RADIANT][index].GetChild(1).heroname = hero_name;
	});
	data.pickedHeroes[DOTA_TEAM_RADIANT].forEach((hero_name, index) => {
		PICKS[DOTA_TEAM_RADIANT][index].GetChild(1).heroname = hero_name;
	});
	data.bannedHeroes[DOTA_TEAM_DIRE].forEach((hero_name, index) => {
		BANS[DOTA_TEAM_DIRE][index].GetChild(1).heroname = hero_name;
	});
	data.pickedHeroes[DOTA_TEAM_DIRE].forEach((hero_name, index) => {
		PICKS[DOTA_TEAM_DIRE][index].GetChild(1).heroname = hero_name;
	});
	STAGE = data.stage;
}

function ChooseCapitan(data) {
	const player_id = data.playerID;
	LOCAL_IS_CAPTAIN = player_id == LOCAL_PLAYER_ID;
	if (PLAYER_IN_TOP_BAR[player_id] != undefined) PLAYER_IN_TOP_BAR[player_id].AddClass("Captain");
}
function UpdateStageHero(map, team, hero_name) {
	map[team].every(function (panel) {
		panel.RemoveClass("CurrentStageAlly");
		panel.RemoveClass("CurrentStageEnemy");
		const hero_icon = panel.GetChild(1);
		if (hero_icon.selected == undefined) {
			hero_icon.selected = true;
			hero_icon.heroname = hero_name;
			return false;
		}
		return true;
	});
	STAGE++;
	UpdateStage();
	STAGE_CAPTAION_BUTTON.SetHasClass("Show", false);
	STAGE_CAPTAION_BUTTON.SetHasClass("SelectStageCaptain", false);
	STAGE_CAPTAION_BUTTON.SetHasClass("BanStageCaptain", false);
}
function PickHeroStage(data) {
	UpdateStageHero(PICKS, data.team, data.heroName);
}
function BanHeroStage(data) {
	UpdateStageHero(BANS, data.team, data.heroName);
}
function UpdateTopInfo(data) {
	UpdateTimerText(data.time, true);
	const is_ally_stage = data.team == LOCAL_TEAM;
	CM_DESCRIPTION_LABEL.text = $.Localize(
		data.is_pick
			? is_ally_stage
				? "Друзья выбирают"
				: "Враги выбирают"
			: is_ally_stage
			? "Друзья банят"
			: "Враги банят",
	);
}
(function () {
	HEROES_ROOTS.forEach((c) => {
		c.RemoveAndDeleteChildren();
	});
	TOP_BAR_RADIENT_ROOT.RemoveAndDeleteChildren();
	TOP_BAR_DIRE_ROOT.RemoveAndDeleteChildren();

	CreateStages();
	CreateTopBar();

	CreateHeroList({
		0: [
			"npc_dota_hero_abaddon",
			"npc_dota_hero_abyssal_underlord",
			"npc_dota_hero_alchemist",
			"npc_dota_hero_axe",
			"npc_dota_hero_beastmaster",
			"npc_dota_hero_brewmaster",
			"npc_dota_hero_bristleback",
			"npc_dota_hero_centaur",
			"npc_dota_hero_chaos_knight",
			"npc_dota_hero_doom_bringer",
			"npc_dota_hero_dragon_knight",
			"npc_dota_hero_earth_spirit",
			"npc_dota_hero_earthshaker",
			"npc_dota_hero_elder_titan",
			"npc_dota_hero_huskar",
			"npc_dota_hero_kunkka",
			"npc_dota_hero_legion_commander",
			"npc_dota_hero_life_stealer",
			"npc_dota_hero_lycan",
			"npc_dota_hero_magnataur",
			"npc_dota_hero_night_stalker",
			"npc_dota_hero_omniknight",
			"npc_dota_hero_pudge",
			"npc_dota_hero_rattletrap",
			"npc_dota_hero_snapfire",
			"npc_dota_hero_sand_king",
			"npc_dota_hero_shredder",
			"npc_dota_hero_skeleton_king",
			"npc_dota_hero_slardar",
			"npc_dota_hero_spirit_breaker",
			"npc_dota_hero_sven",
			"npc_dota_hero_tidehunter",
			"npc_dota_hero_tiny",
			"npc_dota_hero_treant",
			"npc_dota_hero_tusk",
			"npc_dota_hero_undying",
			"npc_dota_hero_wisp",
			"npc_dota_hero_mars",
		],
		1: [
			"npc_dota_hero_arc_warden",
			"npc_dota_hero_antimage",
			"npc_dota_hero_bloodseeker",
			"npc_dota_hero_bounty_hunter",
			"npc_dota_hero_broodmother",
			"npc_dota_hero_clinkz",
			"npc_dota_hero_drow_ranger",
			"npc_dota_hero_ember_spirit",
			"npc_dota_hero_faceless_void",
			"npc_dota_hero_gyrocopter",
			"npc_dota_hero_juggernaut",
			"npc_dota_hero_lone_druid",
			"npc_dota_hero_luna",
			"npc_dota_hero_medusa",
			"npc_dota_hero_meepo",
			"npc_dota_hero_mirana",
			"npc_dota_hero_monkey_king",
			"npc_dota_hero_morphling",
			"npc_dota_hero_naga_siren",
			"npc_dota_hero_nevermore",
			"npc_dota_hero_nyx_assassin",
			"npc_dota_hero_phantom_assassin",
			"npc_dota_hero_phantom_lancer",
			"npc_dota_hero_razor",
			"npc_dota_hero_riki",
			"npc_dota_hero_slark",
			"npc_dota_hero_sniper",
			"npc_dota_hero_spectre",
			"npc_dota_hero_templar_assassin",
			"npc_dota_hero_terrorblade",
			"npc_dota_hero_troll_warlord",
			"npc_dota_hero_ursa",
			"npc_dota_hero_vengefulspirit",
			"npc_dota_hero_venomancer",
			"npc_dota_hero_viper",
			"npc_dota_hero_weaver",
			"npc_dota_hero_pangolier",
			"npc_dota_hero_hoodwink",
		],
		2: [
			"npc_dota_hero_ancient_apparition",
			"npc_dota_hero_bane",
			"npc_dota_hero_batrider",
			"npc_dota_hero_chen",
			"npc_dota_hero_crystal_maiden",
			"npc_dota_hero_dark_seer",
			"npc_dota_hero_dazzle",
			"npc_dota_hero_death_prophet",
			"npc_dota_hero_disruptor",
			"npc_dota_hero_enchantress",
			"npc_dota_hero_enigma",
			"npc_dota_hero_furion",
			"npc_dota_hero_invoker",
			"npc_dota_hero_jakiro",
			"npc_dota_hero_keeper_of_the_light",
			"npc_dota_hero_leshrac",
			"npc_dota_hero_lich",
			"npc_dota_hero_lina",
			"npc_dota_hero_lion",
			"npc_dota_hero_necrolyte",
			"npc_dota_hero_obsidian_destroyer",
			"npc_dota_hero_ogre_magi",
			"npc_dota_hero_puck",
			"npc_dota_hero_pugna",
			"npc_dota_hero_queenofpain",
			"npc_dota_hero_rubick",
			"npc_dota_hero_shadow_demon",
			"npc_dota_hero_shadow_shaman",
			"npc_dota_hero_silencer",
			"npc_dota_hero_skywrath_mage",
			"npc_dota_hero_storm_spirit",
			"npc_dota_hero_techies",
			"npc_dota_hero_tinker",
			"npc_dota_hero_visage",
			"npc_dota_hero_warlock",
			"npc_dota_hero_windrunner",
			"npc_dota_hero_witch_doctor",
			"npc_dota_hero_zuus",
			"npc_dota_hero_winter_wyvern",
			"npc_dota_hero_oracle",
			"npc_dota_hero_dark_willow",
			"npc_dota_hero_grimstroke",
			"npc_dota_hero_void_spirit",
		],
	});
	// UpdateInfo({
	// 	time: 356,
	// 	team: 2,
	// 	useReserveTime: true,
	// 	reserveTime: 120,
	// 	stage: 19,
	// 	pickedHeroes: {
	// 		"2": ["npc_dota_hero_pudge", "npc_dota_hero_pudge", "npc_dota_hero_pudge"],
	// 		"3": ["npc_dota_hero_pudge", "npc_dota_hero_pudge", "npc_dota_hero_pudge"],
	// 	},
	//
	// 	bannedHeroes: {
	// 		"2": ["npc_dota_hero_pudge", "npc_dota_hero_pudge", "npc_dota_hero_pudge"],
	// 		"3": ["npc_dota_hero_pudge", "npc_dota_hero_pudge", "npc_dota_hero_pudge"],
	// 	},
	// 	choicedHeroes: {
	// 		"2": {
	// 			npc_dota_hero_pudge: 0,
	// 			npc_dota_hero_lina: 1,
	// 			npc_dota_hero_sven: 2,
	// 			npc_dota_hero_warlock: 3,
	// 			npc_dota_hero_windrunner: 4,
	// 			npc_dota_hero_weaver: 5,
	// 		},
	// 	},
	// });
	// ChooseCapitan({ team: 2, playerID: 0 });
	// BanHeroStage({ team: 3, heroName: "npc_dota_hero_lina" });
	// BanHeroStage({ team: 3, heroName: "npc_dota_hero_lina" });
	// BanHeroStage({ team: 3, heroName: "npc_dota_hero_lina" });
	// UpdateTopInfo({ time: 30, team: 3, is_pick: false });

	UpdateStage();
	ChooseCapitan({ team: 2, playerID: 0 });
	BanHeroStage({ team: 3, heroName: "npc_dota_hero_lina" });
	BanHeroStage({ team: 2, heroName: "npc_dota_hero_sven" });
	BanHeroStage({ team: 3, heroName: "npc_dota_hero_pudge" });
	BanHeroStage({ team: 2, heroName: "" });
	PickHeroStage({ team: 3, heroName: "" });
	// BanHeroStage({ team: 2, heroName: "npc_dota_hero_dazzle" });
	// PickHeroStage({ team: 3, heroName: "npc_dota_hero_warlock" });
	// PickHeroStage({ team: 2, heroName: "npc_dota_hero_troll_warlord" });
	// PickHeroStage({ team: 3, heroName: "npc_dota_hero_puck" });
})();

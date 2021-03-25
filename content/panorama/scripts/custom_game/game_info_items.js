var item_list = {
	"item_possessed_sword": 0,
	"item_rebels_sword": 0,
	"item_burning_book": 0,
	"item_demons_fury": 0,
	"item_azrael_crossbow": 0,
	"item_burning_blades": 0,
	"item_holy_book": 0,
	"item_holy_book_2": 0,
	"item_double_diff": 0,
	"item_abyssal_blade_2": 0,
	"item_bfury_2": 0,
	"item_damned_swords": 0,
	"item_kings_bar": 0,
	"item_armlet_2": 0,
	"item_armlet_3": 0,
	"item_burning_butterfly": 0,
	"item_manta_2": 0,
	"item_manta_3": 0,
	"item_mjollnir_2": 0,
	"item_sacred_butterfly": 0,
	"item_deaths_mask": 0,
	"item_shivas_guard_2": 0,
	"item_fury_shield": 0,
	"item_talisman_of_ambition": 0,
	"item_dimensional_predictor" : 0,
	"item_vampire_claw" : 0,
	"item_throwing_daggers" : 0,
	"item_devils_helm" : 0,
	"item_corrupted_skull" : 0,
	"item_enchanted_skull" : 0,
	"item_mystical_sword" : 0,
	"item_amber_knife" : 0,
	"item_mozaius_blade" : 0,
	"item_bandoline_blade" : 0,
	"item_sealed_rune" : 0,
	
	"item_static_amulet": 1,
	"item_slice_amulet": 1,
	"item_radiance_2": 1,
	"item_radiance_3": 1,
	"item_hood_of_rage": 1,
	"item_angels_greaves": 1,
	"item_recovery_orb": 1,
	"item_talisman_of_mastery": 1,
	"item_plague_staff": 1,
	"item_devour_helm": 1,
	"item_polar_spear": 1,
	"item_magician_ring": 1,
	"item_life_catcher": 1,
	"item_damned_eye" : 1,
	"item_void_stick" : 1,
	"item_center_of_peace" : 1,
	"item_soul_merchant" : 1,
	"item_consumption_orb" : 1,
	"item_soul_collector" : 1,
	
	
	"item_angels_sword": 2,
	"item_blessed_essence": 2,
	"item_reverse": 2,
	"item_phase_boots_2": 2,
	"item_phase_boots_3": 2,
	"item_amaliels_cuirass": 2,
	"item_snake_boots": 2,
	"item_heart_2": 2,
	"item_spiked_armor": 2,
	"item_lightning_flash": 2,
	"item_death_shield": 2,
	"item_power_treads_3": 2,
	"item_power_treads_2": 2,
	"item_charon": 2,
	"item_pet_hulk": 2,
	"item_pet_mage": 2,
	"item_pet_wolf": 2,
	"item_advanced_midas": 2,
	"item_potion_immune": 2,
	"item_sphere_2": 2,
	"item_heavens_halberd_2": 2,
	"item_wisdom_shard": 2,
	"item_agile_wand": 2,
	"item_knight_talisman": 2,
	"item_cursed_orb": 2,
	"item_boss_soul": 2,
	"item_health_gel" : 2,
	"item_heavy_crossbow" : 2,
	"item_doombolt" : 2,
	"item_soul_stone" : 2,
	"item_dimensional_accelerator" : 2,
	"item_steel_frame" : 2,
	"item_restoration_bracer" : 2,
	"item_material_projector" : 2,
	"item_enigmatic_fire": 2,
	
	"item_tome_lvlup": 3,
	"item_tome_un_6": 3,
	"item_tome_agi_6": 3,
	"item_tome_int_6": 3,
	"item_tome_str_6": 3,
	"item_tome_med": 3,
}

function GetLength(array)
{
	var i = 1;
	
	while(array[i])
		if(array[i])
			i++;
		
	return i;
}

function GetContainerByNumber(number)
{
	if(number == 0)
		return $("#item_phys")
	if(number == 1)
		return $("#item_mag")
	if(number == 2)
		return $("#item_other")
	if(number == 3)
		return $("#item_books")
}

function AddItem(container, item_name)
{
	var ability_container = $.CreatePanel("Panel", container, item_name);
	ability_container.style.margin = "2% 2% 1% 2%"
	ability_container.style.width = "50px";
	ability_container.style.height = "45px";
	
	ability_container.SetPanelEvent( 'onactivate',  (function(item_name) { return function() {OnClick(item_name)}}(item_name)  ) )
	
	var total_layout_string = "<root><Panel><DOTAItemImage class='item' itemname='" + item_name +"' /> </Panel></root>";
	ability_container.LoadLayoutFromStringAsync(total_layout_string, false, false);
}

function OnClick(item_name)
{
	$.Msg(item_name)

	var itemClickedEvent = {
		"link": ( "dota.item." + item_name ),
		"shop": 0,
		"recipe": 0
	};
	GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
	var data = {
		"itemname" : ( "dota.item." + item_name),
		"PlayerID": 0,
		"itemcost": 125,
	}
	GameEvents.SendEventClientSide( "dota_item_purchase", data );
}

function _init()
{
	for(j = 0; j < 3; j++)
	{
		for(i = 0; i < GetContainerByNumber(j).GetChildCount(); i++)
		{
			GetContainerByNumber(j).GetChild(i).DeleteAsync(0.0)
		}
	}
	
	for(var item_name in item_list)
	{
		AddItem(GetContainerByNumber(item_list[item_name]), item_name)
	}
	
}

(function()
{
	_init()
})();
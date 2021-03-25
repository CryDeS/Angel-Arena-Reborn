function OnDragDrop(cur_panel, new_panel, slot)
{
	if(!new_panel)
		return;
	
	var entIndex = new_panel.contextEntityIndex
	
	if(entIndex == undefined)
		return;
	
	GameEvents.SendCustomGameEventToServer("aa_on_drop_item_to_slot", { idx : entIndex, slt : slot } );
}

function setHandler( panel, slot )
{
	$.RegisterEventHandler("DragDrop", panel, function(curPanel, newPanel) { OnDragDrop(curPanel, newPanel, slot); });
}

(function () {
	let dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	
	let neutralHud = dotaHud.FindChildTraverse("inventory_neutral_slot_container").FindChildTraverse("AbilityButton")

	if( neutralHud._aa_dirty_hack_for_no_second_update == 1 )
		return;
	
	// neutral slot
	setHandler(neutralHud, 16)
	
	let inventoryHolder = dotaHud.FindChildTraverse("InventoryContainer")
	
	// inventory and backpack
	for( let i = 0; i < 9; ++ i)
	{
		let slotPanel = inventoryHolder.FindChildTraverse( "inventory_slot_" + i ).FindChildTraverse("AbilityButton")
		setHandler(slotPanel, i)
	}
	
	// stash
	let stashHolder = dotaHud.FindChildTraverse("stash_row")
	
	for( let i = 9; i < 15; ++ i)
	{
		let slotPanel = stashHolder.FindChildTraverse("inventory_slot_" + (i - 9) ).FindChildTraverse("AbilityButton")
		setHandler(slotPanel, i)
	}
	
	neutralHud._aa_dirty_hack_for_no_second_update = 1
})()
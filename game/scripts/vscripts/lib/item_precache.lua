ItemPrecache = ItemPrecache or class({})

local itemNames = {
	"item_soul_stone",
	"item_doombolt",
	"item_heavy_crossbow",
	"item_azrael_crossbow",
	"item_amber_knife",
	"item_dark_edge",
	"item_mozaius_blade",
	"item_mystical_sword",
	"item_damned_swords",
	"item_burning_book",
	"item_shard_hola",
	"item_shard_huntress",
	"item_shard_joe_black",
	"item_shard_satan",
}

function ItemPrecache:Precache(context)
	for _, item in pairs(itemNames) do
		PrecacheItemByNameAsync(item, function() end)
	end
end
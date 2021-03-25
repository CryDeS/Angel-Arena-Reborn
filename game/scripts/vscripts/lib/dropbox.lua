require('lib/random/generators')

local CONFIG_PATH = "scripts/npc/dropbox.kv"
local POS_RANDOM_TYPE = "uniform"
local ITEM_DESTROY_TIME = 60

-- Internals
local POS_RAND_GEN = RandomGeneratorFactory:GetGenerator(POS_RANDOM_TYPE)

local types = {
	['uniform_list'] = require('lib/dropbox_types/uniform_list'),
	['garant_list']  = require('lib/dropbox_types/garant_list'),
}

DropBox = DropBox or class({})

function DropBox:_Init()
	if self.inited then return end

	if not IsInToolsMode() then
		self.intied = true
	end

	local kv = LoadKeyValues(CONFIG_PATH)

	local data = {}

	for boxName, boxData in pairs(kv) do
		local boxType = boxData['type']

		if not boxType then
			print("[DropBox] Failed to parse loot-box named", boxName, "no lootbox type")
			return
		end

		local classGenerator = types[boxType]

		if not classGenerator then
			print("[DropBox] Failed to parse loot-box named", boxName, "lootbox type '", boxType ,"'is not supported")
			return
		end

		local childList

		local childData = boxData['childs']

		if childData then
			local childs = {}

			for childName, _ in pairs(childData) do
				table.insert(childs, childName)
			end

			childList = childs
		end

		data[boxName] = {
			["generator"] = classGenerator( boxData ),
			["childList"] = childList,
		}
	end

	self.data = data
end

function DropBox:GetDropbox( boxName )
	local boxData = self.data[boxName]

	if not boxData then
		print("[DropBox] Failed to get box, there is no box named", boxName, debug.traceback() )
		return nil
	end

	local childList = boxData['childList']

	local childs = {}

	if childList then
		for _, childName in pairs(childList) do
			local child = DropBox:GetDropbox( childName )

			if not child then
				print("[DropBox] failed to get box child for box ", boxName )
				return nil
			end

			table.insert(childs, child)
		end
	end

	local result = DropBox()

	result.identifier = boxName
	result.generator  = boxData["generator"]
	result.childs 	  = childs

	return result
end

function DropBox:GetItemNames()
	local items = self.generator:GetItems()
	return self.generator:GetItems()
end

local ItemDestroyer = class({})

function ItemDestroyer:LaunchCountdown(items)
	local res = ItemDestroyer()

	res.items = items
	res:start()
end

function ItemDestroyer:start()
	if not self.items then return end

	Timers:CreateTimer( ITEM_DESTROY_TIME, function()
		print("Starting destroy items")
		for _, data in pairs(self.items) do
			local item = data[1]
			local drop = data[2]

			if item and IsValidEntity(item) and not item:GetOwnerEntity() then
				if drop and IsValidEntity(drop) then 
					UTIL_Remove(drop) 
				end

				UTIL_Remove(item)
			end
		end

		print("End destroy items")
	end)
end

function DropBox:DropAtPos(pos, radius, manualLifetime)
	print("[DropBox] Starting drop", self.identifier)

	local items = self:GetItemNames()

	local result = {}

	for _, itemData in pairs(items) do
		local function MakeItem(itemName)
			local itemPos = pos + Vector( POS_RAND_GEN() * radius, POS_RAND_GEN() * radius, 0)
			
			local item = CreateItem(itemName, nil, nil)

			if not item then return nil end

			item:SetCurrentCharges( item:GetInitialCharges() )

			item:SetPurchaseTime(0)

			local drop = CreateItemOnPositionSync( pos, item )

			if not drop then return end

			item:LaunchLoot(false, 300, 0.75, itemPos)

			table.insert( result, {item, drop} )

			return item
		end

		local itemName  = itemData[1]
		local itemCount = itemData[2]

		
		local item = MakeItem( itemName )

		if item then
			if item:IsStackable() then
				item:SetCurrentCharges(itemCount)
			else
				for i = 1, itemCount - 1 do
					MakeItem(itemName)
				end
			end
		end
	end

	for _, child in pairs( self.childs ) do
		child:DropAtPos(pos, radius)
	end

	print("[DropBox] Stop dropping items")

	if not manualLifetime then
		return ItemDestroyer:LaunchCountdown( result )
	else
		return result
	end

end

DropBox:_Init()
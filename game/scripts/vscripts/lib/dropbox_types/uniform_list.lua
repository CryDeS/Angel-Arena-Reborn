require('lib/random/generators')

local RAND_GEN = RandomGeneratorFactory:GetGenerator("uniform")
local LOOT_GEN = RandomGeneratorFactory:GetGenerator("uniform")

UniformDropBox = UniformDropBox or class({})

local function Make(data)
	local items  = {}
	local chance = tonumber(data['chance'] or 0) / 100

	for item, count in pairs(data['items']) do
		table.insert(items, { item, count })
	end

	local res = UniformDropBox()

	res.items = items
	res.chance = chance

	return res
end

function UniformDropBox:GetItems()
	local val = RAND_GEN()

	local result = {}

	if val > self.chance then 
		return result
	end

	local items = self.items

	local baseValue = LOOT_GEN(1, #items + 1)

	local i = math.floor( baseValue)

	table.insert(result, items[i])

	return result
end

return Make
GarantDropBox = GarantDropBox or class({})

local function Make(data)
	local items = {}

	for item, count in pairs(data['items']) do
		table.insert(items, { item, count })
	end

	local res = GarantDropBox()
	res.items = items

	return res
end

function GarantDropBox:GetItems()
	return self.items
end

return Make
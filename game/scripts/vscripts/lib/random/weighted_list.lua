WeightedList = WeightedList or class({})

function WeightedList:Create(list, randomGenerator)
	if not list then return nil end
	if not randomGenerator then return nil end

	local len = #list

	if len == 0 then return nil end


	local sumWeight = 0
	local array = {}

	for _, data in pairs( list ) do
		local weight = data[1]
		local choice = data[2]

		sumWeight = sumWeight + weight
	end

	local item = WeightedList()

	item.sumWeight  = sumWeight
	item.list 		= list
	item.generator  = randomGenerator

	return item
end

function WeightedList:Get()
	local number = self.generator() * self.sumWeight

	local last

	for _, data in pairs(self.list) do
		local weight = data[1]
		local choice = data[2]

		if weight > number then
			return choice
		end

		last = choice
	end

	return last
end
queue_t = queue_t or class({})

function queue_t:init(maxLen)
	self.data = {}
	self.maxLen = maxLen
end

-- add new element
function queue_t:push(pos)
	if #self.data > self.maxLen then
		table.remove(self.data, 1)
	end

	table.insert(self.data, pos)
end

function queue_t:front()
	if self:empty() then return nil end

	return self.data[1]
end

-- return last element and erase it, return nil if queue is empty
function queue_t:pop()
	if #self.data == 0 then return nil end

	local element = table.remove(self.data)

	return element
end

function queue_t:see()
	local nElement = #self.data

	if nElement == 0 then 
		return nil
	end

	return self.data[nElement]
end

function queue_t:empty()
	return #self.data == 0
end

function queue_t:clear()
	self:init(self.maxLen)
end

function MakeQueue(maxLen)
	local res = queue_t()
	res:init(maxLen)
	return res
end
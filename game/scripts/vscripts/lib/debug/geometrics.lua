--[[
 Debug draw class
 Methods:
  id Geometrics:AddLine(vFrom, vTo, [vColor], [ztest]) 	-- add draw line from pos vFrom to pos vTo, with optional color vColor, and optional z-test flag ztest. 
  void Geometrics:RemoveLine(lineID) 					-- remove line with id from draw
]]

require('lib/timers')

if not Geometrics then
	_G.Geometrics = class({})
	Geometrics.__inited = false 
else 
	Geometrics.fini() 
	Geometrics.__inited = false 
end

function Geometrics:init()
	self.indexes = {}
	self.objects = {}
	self:_init_type("line")
	self:_init_type("line2d")

	Timers:CreateTimer("__geometrics", { 
			endtime = 0.5,
			callback = function() 
				self:_tick() 
				return 0.5 
			end })
end 

function Geometrics:fini() 
	Timers:RemoveTimer("__geometrics");
end 

function Geometrics:_init_type(typename)
	self.indexes[typename] = 1
	self.objects[typename] = {}
end 

function Geometrics:_indexof(typename)
	local idx = self.indexes[typename]
	self.indexes[typename] = self.indexes[typename] + 1
	return idx 
end 

function Geometrics:_tick()
	for _, line in pairs(self.objects["line"]) do
		DebugDrawLine_vCol(line.from, line.to, line.color, line.ztest, 0.51)
	end 
end 

function Geometrics:AddLine(from, to, ...)
	local argc = select("#", ...)

	local color = Vector(255, 0, 0)
	local ztest = true 

	if argc >= 1 then
		color = select("1", ...)
	end 

	if argc >= 2 then
		ztest = select("2", ...)

		if type(ztest) ~= "bool" then error("ztest must be boolean type!") end 
	end 

	local idx = self:_indexof("line")

	local data = {
		from = from, 
		to = to, 
		color = color, 
		ztest = ztest
	}

	self.objects["line"][idx] = data

	return idx 
end 

function Geometrics:RemoveLine(idx)
	if self.objects["line"][idx] then
		table.remove(self.objects["line"], idx)
	end 
end 

if not Geometrics.__inited or GameRules:IsCheatMode() then
	Geometrics:init() 	
	Geometrics.__inited = true 
end 

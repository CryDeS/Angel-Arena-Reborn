require('lib/queue_t')

move_limiter = move_limiter or class({})

function MakeMoveLimiter(unit, checkfunc, nHistorySteps, checkLen, basePosition)
	local res = move_limiter()
	res:init(unit, checkfunc, nHistorySteps, checkLen, basePosition)
	return res
end

function move_limiter:init(unit, checkfunc, nHistorySteps, checkLen, basePosition)
	self.unit			= unit
	self.checkfunc		= checkfunc
	self.checkLen		= checkLen
	self.queue			= MakeQueue(nHistorySteps)
	self.basePosition	= basePosition
end

function move_limiter:findPos()
	local unit 		= self.unit
	local checkfunc = self.checkfunc
	local queue 	= self.queue

	local lastPos = queue:pop() -- just remove this position because maybe this pos WAS invalid

	while lastPos and not checkfunc(unit, lastPos) do
		lastPos = queue:pop()
	end


	return lastPos
end

function move_limiter:tick()
	local unit 		= self.unit
	local queue 	= self.queue

	local unitPos = unit:GetAbsOrigin()
	local lastPos = queue:see()

	if self.checkfunc(unit, unitPos) then
		if not lastPos or ( (lastPos - unitPos):Length() > self.checkLen ) then
			queue:push( unitPos )
		end

	else
		lastPos = self:findPos()

		local hasPos = lastPos ~= nil

		if not lastPos then
			lastPos = self.basePosition
		end

		unit:Interrupt()
		unit:InterruptChannel()
		unit:InterruptMotionControllers(true)
		FindClearSpaceForUnit(unit, lastPos, false)

		self:tick() -- and check now again is there all is ok?
	end
end
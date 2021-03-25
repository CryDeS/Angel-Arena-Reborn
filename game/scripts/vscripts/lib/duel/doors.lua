require('lib/math_extra')

local DOOR_OPEN_TIME = 0.7

doors_cache = doors_cache

DuelDoors = DuelDoors or class({})

function DuelDoors:SubOpenDoor(t)
	local door 			= self.door
	local doorBasePos 	= self.doorBasePos
	local doorHeight 	= self.doorHeight

	if not door or door:IsNull() then return end
	
	t = clamp(t, 0.1, 1) -- clamp( v, 0.1, 1), 0.1 because we dont want to fully disable that door

	local newPos = doorBasePos - Vector(0, 0, doorHeight * (1 - t))

	door:SetAbsOrigin(newPos)
end

function DuelDoors:SetObstaclesState( state )
	for _, obstacle in pairs(self.obstacles) do
		obstacle:SetEnabled( state, true )
	end
end

function DuelDoors:MakeParticles()
	local door = self.door
	local pos = self.doorBasePos - Vector(0,0,60) -- hm, that for a kinda-cinematic look

	local particle = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015_dust.vpcf", PATTACH_CUSTOMORIGIN, door)
	ParticleManager:SetParticleControlEnt(particle, 0, door, PATTACH_CUSTOMORIGIN, "start_at_customorigin", pos, false)
	door:EmitSound("BARNDOORS_OPEN")
end

function DuelDoors:OpenDoor( isOpenIn )
	self.opening = isOpenIn

	self.target = 1
	self.speedMult = 1

	if self.opening then
		self.target = 0
		self.speedMult = -1
	end

	self:MakeParticles()

	if not self.opening then
		self:SetObstaclesState( true )
	end

	if self.timer then
		Timers:RemoveTimer( self.timer )
	end

	self.timer = Timers:CreateTimer( 0, function()
		local dt = FrameTime()

		local currentState = self.doorState

		local speed = dt / DOOR_OPEN_TIME

		local newVal = clamp(currentState + self.speedMult * speed, 0, 1 )

		currentState = lerp( 0, 1, newVal )

		self:SubOpenDoor( currentState )

		self.doorState = currentState

		if currentState == self.target then
			if self.opening then
				self:SetObstaclesState( false )
			end

			return nil
		end

		return 0
	end)
end

local _makeDoor = function( doorIn, doorBasePos, doorHeight, doorState, obstacles )
	local door = DuelDoors()

	door.door 			= doorIn
	door.doorBasePos 	= doorBasePos
	door.doorHeight 	= doorHeight
	door.doorState 		= doorState
	door.obstacles 		= obstacles

	return door
end

local InvalidateCache = function()
	if doors_cache then return end

	local doorNames = {
		{ "aa_prop_door_1", { "aa_prop_door_1_obstacle_1", "aa_prop_door_1_obstacle_2", "aa_prop_door_1_obstacle_3" } },
		{ "aa_prop_door_2", { "aa_prop_door_2_obstacle_1", "aa_prop_door_2_obstacle_2", "aa_prop_door_2_obstacle_3" } },
	}

	local doors = {}

	for _, doorData in pairs(doorNames) do
		local doorName = doorData[1]

		local door = Entities:FindByName(nil, doorName)

		if not door then
			print("[Duel] Door", doorName, " is not exists on map")
			return
		end

		local obstacles = {}

		for _, obstacleName in pairs(doorData[2]) do
			local obstacle = Entities:FindByName(nil, obstacleName)

			if not obstacle then
				print("[Duel] Door ", doorName, " obstacle ", obstacleName, " is not exists on map")
				return
			end

			table.insert( obstacles, obstacle )
		end

		local bbMin = door:GetBoundingMins()
		local bbMax = door:GetBoundingMaxs()

		table.insert(doors, _makeDoor( door, door:GetAbsOrigin(), (bbMax - bbMin).z, 1.0, obstacles) )
	end

	doors_cache = doors
end

function DuelDoors:Precache( context )
	context:AddResource("particles/econ/events/fall_major_2015/teleport_start_fallmjr_2015_dust.vpcf")
	context:AddResource("soundevents/game_sounds_ui_imported.vsndevts")
end

function DuelDoors:SetDoorsState(state)
	InvalidateCache()

	if not doors_cache then return end

	for _, door in pairs(doors_cache) do
		door:OpenDoor(state)
	end
end
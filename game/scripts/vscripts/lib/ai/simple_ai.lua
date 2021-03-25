require('lib/timers')
require('lib/ai/ai_helpers')
require('lib/ai/ai_actions')

SimpleAI = SimpleAI or class({})

function SimpleAI:OnTick()
	if not self:IsValid() then return nil end
	
	if not self:CanThink() then return self.tickTime end

	local spawnPos = self.spawnPos
	local caster = self.unit

	if spawnPos == nil then
		spawnPos = caster:GetAbsOrigin()
		self.spawnPos = spawnPos 
	end

	local baseAoi = self.baseAoi

	local enemies = AIHelpers:GetEnemiesNear(caster, caster:GetAbsOrigin(), caster:GetTeamNumber(), baseAoi)

	for _, action in pairs(self.actions) do

		if action:Do(enemies, spawnPos, baseAoi) then
			return self.tickTime
		end
	end

	return self.tickTime
end 

function SimpleAI:IsValid()
	local unit = self.unit

	if not unit or unit:IsNull() or not unit:IsAlive() or unit:IsDominated() or unit:IsIllusion() then return false end

	return true
end

function SimpleAI:CanThink()
	for _, action in pairs(self.actions) do
		if action:ForbiddenThink() then return false end
	end

	return true
end

function SimpleAI:Make( unit, tickTime, aoi, actions)
	local ai = SimpleAI() 

	ai.baseAoi 	= aoi
	ai.tickTime = tickTime
	ai.unit 	= unit
	ai.actions  = actions

	Timers:CreateTimer(ai.tickTime, function() return ai:OnTick() end )
end
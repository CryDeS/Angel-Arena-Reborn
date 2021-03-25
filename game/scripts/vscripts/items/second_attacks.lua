SecondAttacks = SecondAttacks or class({})

MeleeSecondAttack  = SecondAttacks()
RangedSecondAttack = SecondAttacks()

function SecondAttacks:RegisterSecondAttack( modName )
	if not IsServer() then return end

	table.insert(self.secondAttacks, modName)
end

function SecondAttacks:CanSecondAttack( hero )
	if not IsServer() then return false end

	for _, modName in pairs(self.secondAttacks) do
		if hero:HasModifier(modName) then return false end
	end

	return true
end

function SecondAttacks:_Init()
	if not IsServer() then return end

	self.secondAttacks = self.secondAttacks or {}
end

MeleeSecondAttack:_Init()
RangedSecondAttack:_Init()
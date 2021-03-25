math = require('math')

item_enigmatic_fire = class({})

--------------------------------------------------------------------------------


function item_enigmatic_fire:CastFilterResultTarget( hTarget )
	local seek 
	if self:GetCaster():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		seek = "radiant"
	else 
		seek = "dire"
	end 

	if string.find(hTarget:GetUnitName(), seek) then
		return UF_SUCCESS
	else 
		return UF_FAIL_CUSTOM
	end 
end


function item_enigmatic_fire:GetCustomCastErrorTarget( hTarget )
	return "#dota_hud_error_cant_cast_on_enemy"
end 

function item_enigmatic_fire:OnSpellStart() 
	if not IsServer() then return end 

	self.target = self:GetCursorTarget() 
	self.interval = 0 
	self.fini = false 
	self.done = false 
end

function item_enigmatic_fire:OnChannelThink( fInterval )
	if not IsServer() then return end 
	if self.done then return end 

	self.interval = self.interval + fInterval*10
	local rounded = math.floor(self.interval + 0.5 )

	if rounded == 0 then return end 

	self.interval = self.interval - rounded

	local charges = self:GetCurrentCharges() 
	charges = charges - rounded 

	local health_pct = (self.target:GetHealth() / self.target:GetMaxHealth() ) * 100
	
	if health_pct >= 100 then
		self:GetCaster():Interrupt() 
		self:GetCaster():InterruptChannel() 
		return 
	end 

	if charges < 0 then
		rounded = self:GetCurrentCharges() 
		self:SetCurrentCharges( 0 )
		self:GetCaster():Interrupt() 
		self:GetCaster():InterruptChannel() 
		charges = 0 
	else 
		self:SetCurrentCharges(charges)
	end

	health_pct = (health_pct + rounded)

	if health_pct >= 99.5 then
		health_pct = 100 
		self.fini = true 
		local caster = self:GetCaster()
		if caster then
			caster:Interrupt() 
			caster:InterruptChannel() 
		end
	end 

	local health = (self.target:GetMaxHealth() / 100)*health_pct
	if health <= 1 then health = 1; end 

	self.target:SetHealth( health )	
end 

function item_enigmatic_fire:OnChannelFinish( bInterrupted )
	if not IsServer() then return end 

	if self.fini then
		local ability = self.target:GetAbilityByIndex(0)
		ability:OnStateChanged(false, nil)
	end 

	if self:GetCurrentCharges() == 0 then 
		self:Destroy() 
	end 

	self.done = true 
	self.fini = false 
end 
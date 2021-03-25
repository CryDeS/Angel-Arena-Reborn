creep_mage_channel = class({})


function creep_mage_channel:OnSpellStart() 
	if not IsServer() then return end 

	self.radius		= self:GetSpecialValueFor("radius")
	self.damage 	= self:GetSpecialValueFor("damage")
	self.dmg_type 	= self:GetAbilityDamageType() 
	self.speed 		= self:GetSpecialValueFor("projectile_speed")
	self.interval 	= self:GetSpecialValueFor("projectile_interval")
	self.angle 		= math.rad( self:GetSpecialValueFor("angle") )

	self.dTime 		= 0
	self.count 		= 0
	self.done 		= false 
end 

function creep_mage_channel:OnChannelThink( fInterval )
	if not IsServer() then return end 
	if self.done then return end 

	local caster = self:GetCaster() 
	
	self.dTime = self.dTime + fInterval

	while (self.dTime > self.interval) do
		local rotate_vec = Vector(math.cos(self.count * self.angle) - math.sin(self.count * self.angle), math.cos(self.count * self.angle) + math.sin(self.count * self.angle) , 0)
		local vector = (caster:GetForwardVector() + rotate_vec):Normalized() 

		local info =
	    {
	    	Ability = self,
        	EffectName = "particles/mage_ball/mage_ball.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = self.radius,
        	fStartRadius = 48,
        	fEndRadius = 64,
        	Source = caster,
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + self.radius/self.speed + 1,
			bDeleteOnHit = false,
			vVelocity = vector * self.speed,
			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    ProjectileManager:CreateLinearProjectile(info)

	    self.dTime = self.dTime - self.interval
	    self.count = self.count + 1
	end 
end 

function creep_mage_channel:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end 
	if not hTarget then return end 

	ApplyDamage({
		victim = hTarget,
		attacker = self:GetCaster(),
		ability = self, 
		damage = self.damage,
		damage_type = self.dmg_type, 
	})
end 

function creep_mage_channel:OnChannelFinish( bInterrupted )
	if not IsServer() then return end 

	self.done = true 
end 




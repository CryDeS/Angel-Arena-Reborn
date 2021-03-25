huntress_curse_arrow = huntress_curse_arrow or class({})
local debuffModifier = "modifier_huntress_curse_arrow"
LinkLuaModifier(debuffModifier, "heroes/huntress/huntress_curse_arrow/" .. debuffModifier, LUA_MODIFIER_MOTION_NONE)

function huntress_curse_arrow:OnSpellStart()
	if not IsServer() then return end
	self.target = self:GetCursorTarget()
	
	if self.target:TriggerSpellAbsorb(self) or self.target:TriggerSpellReflect(self) then return end
	
	self.channelTime = 0
	self.min_duration = self:GetSpecialValueFor("min_duration")
	self.max_duration = self:GetSpecialValueFor("max_duration")
end

function huntress_curse_arrow:OnChannelThink(intervalTime)
	self.channelTime = self.channelTime + intervalTime
end

function huntress_curse_arrow:OnChannelFinish()
	if not self.target:IsAlive() then return end
	local caster = self:GetCaster()

	local info =
	{
		Target = self.target,
		Source = caster,
		Ability = self,
		EffectName = "particles/huntress/huntress_curse_arrow/huntress_curse_arrow.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function huntress_curse_arrow:OnProjectileHit(target)
	if not self then return end
	local duration = self.channelTime / self:GetChannelTime() * (self.max_duration - self.min_duration) + self.min_duration
	target:AddNewModifier(self:GetCaster(), self, debuffModifier, { duration = duration })
end

function huntress_curse_arrow:OnInventoryContentsChanged()
	self:SetLevel(1)
	self:SetHidden(not self:GetCaster():HasModifier("modifier_azrael_crossbow"))
end

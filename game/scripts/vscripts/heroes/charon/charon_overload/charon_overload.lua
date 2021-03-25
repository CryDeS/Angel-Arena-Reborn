charon_overload = charon_overload or class({})

local CAST_SOUND    = "Hero_Charon.Overload.Cast"
local TARGET_SOUND  = "Hero_Charon.Overload.Target"

------------------------------------------------------------------------------
function charon_overload:OnSpellStart()
	self.target = self:GetCursorTarget()
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
	self.damage_constant = self:GetSpecialValueFor("damage_constant")
	self.damage_for_mana_pct = self:GetSpecialValueFor("damage_for_mana_pct")
	if self.target:TriggerSpellAbsorb(self) then
		return
	end
	self:ShotArcTarget(self:GetCaster(), self.target)

	EmitSoundOn(CAST_SOUND, self:GetCaster())
end

------------------------------------------------------------------------------
function charon_overload:ShotArcTarget(firstTarget, secondTarget)
	local info =
	{
		Target = secondTarget,
		Source = firstTarget,
		Ability = self,
		EffectName = "particles/charon/charon_overload/charon_overload.vpcf",
		iMoveSpeed = self.projectile_speed,
		vSourceLoc = firstTarget:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end


------------------------------------------------------------------------------
function charon_overload:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local info = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage_constant + self:GetCaster():GetMaxMana() / 100 * self.damage_for_mana_pct,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(info)

		EmitSoundOn(TARGET_SOUND, hTarget)
	end
end

------------------------------------------------------------------------------
function charon_overload:GetManaCost()
	local caster = self:GetCaster()
	local pct_cost = self:GetSpecialValueFor("damage_for_mana_pct")
	local mana_cost = caster:GetMaxMana() / 100 * pct_cost
	mana_cost = mana_cost - (mana_cost * caster:GetTalentSpecialValueFor("charon_overload_manacost_reduction_percent_tallent"))
	return mana_cost
end

--------------------------------------------------------------------------------
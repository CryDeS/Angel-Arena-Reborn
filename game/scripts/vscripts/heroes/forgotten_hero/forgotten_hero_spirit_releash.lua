forgotten_hero_spirit_releash = forgotten_hero_spirit_releash or class({})

local ability = forgotten_hero_spirit_releash

LinkLuaModifier( "modifier_forgotten_hero_spirit_releash_debuff", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_spirit_releash_debuff", LUA_MODIFIER_MOTION_NONE )

function ability:GetCooldown( nLevel )
	local cd = self.BaseClass.GetCooldown(self, nLevel)
	
	if self:GetLevel() ~= 0 then
		local parent = self:GetCaster()

		cd = cd - parent:GetTalentSpecialValueFor("forgotten_hero_talent_spirit_releash_cd_decrease")
	end

	return cd
end

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster = self:GetCaster()

	local caster 	= self:GetCaster()
	local vPos 		= self:GetCursorPosition()
	local distance 	= self:GetCastRange( caster:GetAbsOrigin(), nil) + caster:GetCastRangeBonus()
	local speed 	= self:GetSpecialValueFor("projectile_speed")
	local width 	= self:GetSpecialValueFor("projectile_width")

	local casterPos = caster:GetAbsOrigin()

	if vPos == casterPos then
		vPos = casterPos + Vector(0,1,0)
	end

	local vDirection = (vPos - casterPos):Normalized()


	local info = 
	{
		EffectName 		= "particles/heroes/forgotten_hero/spirit_releash/spirit_releash.vpcf",
		Ability 		= self,
		vSpawnOrigin 	= casterPos,
		fStartRadius 	= width,
		fEndRadius 		= width,
		vVelocity 		= speed * vDirection,
		fDistance 		= distance,
		Source 			= caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )

	caster:EmitSound("Hero_ForgottenHero.SpiritReleash.Start")

	-- TODO: Sound, particle
end

function ability:OnProjectileHit( hTarget, vLocation )
	if not hTarget then return false end
	if hTarget:IsMagicImmune() then return false end
	if hTarget:IsInvulnerable() then return false end

	local caster = self:GetCaster()

	local damage = 
	{
		victim 	 	= hTarget,
		attacker 	= caster,
		damage 		= self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		ability 	= self,
	}

	ApplyDamage( damage )

	if caster:HasTalent("forgotten_hero_talent_spirit_releash_stun") then
		local duration = caster:GetTalentSpecialValueFor("forgotten_hero_talent_spirit_releash_stun")

		hTarget:AddNewModifier(caster, self, "modifier_forgotten_hero_spirit_releash_debuff", { duration = duration })
	end

	caster:EmitSound("Hero_ForgottenHero.SpiritReleash.Hit")

	-- TODO: particle

	return false
end

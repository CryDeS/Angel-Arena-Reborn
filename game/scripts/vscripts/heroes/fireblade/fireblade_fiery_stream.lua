fireblade_fiery_stream = fireblade_fiery_stream or class({})

local ability = fireblade_fiery_stream

LinkLuaModifier( "modifier_fireblade_fiery_stream_buff",   'heroes/fireblade/modifiers/modifier_fireblade_fiery_stream_buff',   LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fireblade_fiery_stream_debuff", 'heroes/fireblade/modifiers/modifier_fireblade_fiery_stream_debuff', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fireblade_fiery_stream_talent", 'heroes/fireblade/modifiers/modifier_fireblade_fiery_stream_talent', LUA_MODIFIER_MOTION_HORIZONTAL )

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster 	 = self:GetCaster()
	local vPos 		 = self:GetCursorPosition()
	local distance 	 = self:GetSpecialValueFor("distantion")
	local casterPos  = caster:GetAbsOrigin()
	local vDirection = (vPos - casterPos):Normalized()

	local speed = 2400
	local width = 200

	local info = 
	{
		EffectName 		= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
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

	EmitSoundOn( "Hero_Lina.DragonSlave", caster )

	if caster:HasTalent("fireblade_talent_fire_stream_blink") then
		caster:AddNewModifier(caster, self, "modifier_fireblade_fiery_stream_talent", { duration = -1, speed = speed, posx = vPos.x, posy = vPos.y, posz = vPos.z, offset = width })
	end
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

	if hTarget:IsRealHero() then
		caster:AddNewModifier(caster, self, "modifier_fireblade_fiery_stream_buff", { duration = self:GetSpecialValueFor("buff_duration") })
	end

	hTarget:AddNewModifier(caster, self, "modifier_fireblade_fiery_stream_debuff", { duration = self:GetSpecialValueFor("slow_duration") })

	return false
end

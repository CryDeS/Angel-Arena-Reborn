spider_one_grid = spider_one_grid or class({})
LinkLuaModifier( "modifier_spider_one_grid", 'creeps/abilities/modifiers/modifier_spider_one_grid', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_one_grid_stun", 'creeps/abilities/modifiers/modifier_spider_one_grid_stun', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spider_one_grid:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local info = {
			EffectName = "particles/neutral_fx/dark_troll_ensnare_proj.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "grid_speed" ),
			Source = caster,
			Target = target,
			bDodgeable = true,
			bProvidesVision = true, 
			iVisionRadius = 400, 
			--iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_NagaSiren.Ensnare.Cast", caster )
end

function spider_one_grid:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_NagaSiren.Ensnare.Target", hTarget )

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spider_one_grid", { duration = self:GetSpecialValueFor("duration")} )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spider_one_grid_stun", { duration = 0.0001 } )
	end

	return true
end

modifier_ghost_small_red_magic_fire = class({})

--------------------------------------------------------------------------------

function modifier_ghost_small_red_magic_fire:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_magic_fire:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_magic_fire:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_red_magic_fire:OnCreated(kv)
	self.damage = kv.damage 
	self.duration = kv.duration
	
	ApplyDamage( {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
				} )

	if IsServer() then 
		self.count = 2;
		Timers:CreateTimer(1, function() 
			if not self or not self.count or not self.duration or not self.damage then return nil end 
			self.count = self.count + 1

			ApplyDamage( {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
				} )

			if self.count > self.duration then return nil end 

			return 1 
		end )
	end 
end 

--------------------------------------------------------------------------------

function modifier_ghost_small_red_magic_fire:GetEffectName()
	return "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_cast_staff_fire.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ghost_small_red_magic_fire:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

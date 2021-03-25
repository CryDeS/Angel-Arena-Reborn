modifier_joe_black_song_debuff = class({})

function modifier_joe_black_song_debuff:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf"
end

function modifier_joe_black_song_debuff:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	local parent = self:GetParent()

	if IsServer() then
		ApplyDamage({
			attacker    = self:GetCaster(),
			victim      = parent,
			damage      = ability:GetSpecialValueFor("finish_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability     = ability
		})

		local dmg_part = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl( dmg_part, 0, parent:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(dmg_part)

		parent:EmitSound("Hero_QueenOfPain.ShadowStrike")
	end

	self.miss_chance 	   = ability:GetSpecialValueFor("miss_chance")
	self.fixed_vision 	   = ability:GetSpecialValueFor("fixed_vision")
	self.status_resistance = -ability:GetSpecialValueFor("status_resistance")
end

function modifier_joe_black_song_debuff:CheckState( ... )
	return {
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true
	}
end

function modifier_joe_black_song_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION 
	}
end

function modifier_joe_black_song_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_joe_black_song_debuff:GetModifierStatusResistanceStacking()
	return self.status_resistance 
end

function modifier_joe_black_song_debuff:GetFixedDayVision()
	return self.fixed_vision
end

function modifier_joe_black_song_debuff:GetFixedNightVision()
	return self.fixed_vision
end

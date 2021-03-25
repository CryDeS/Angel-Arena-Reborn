satan_trade = class({})
LinkLuaModifier("modifier_satan_trade_attack", "heroes/satan/satan_bloody_trade/modifier_satan_trade_attack", LUA_MODIFIER_MOTION_NONE)

function satan_trade:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local health_lose  = self:GetSpecialValueFor("health_lose") / 100
	local duration     = self:GetSpecialValueFor("duration")
	local damage_pct   = self:GetSpecialValueFor("damage_get") / 100

	local talent_damage   = caster:FindAbilityByName("satan_special_bonus_trade_damage")
	local talent_duration = caster:FindAbilityByName("satan_special_bonus_trade_duration")

	local health_lost = caster:GetMaxHealth()*health_lose

	ApplyDamage({
		victim = caster,
		attacker = caster,
		damage = health_lost,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_REFLECTION, -- no amplify and no blade mail jokes
		ability = self,
	})

	if talent_damage then
		damage_pct = damage_pct + talent_damage:GetSpecialValueFor("value") / 100
	end

	if talent_duration then
		duration = duration + talent_duration:GetSpecialValueFor("value")
	end

	local bonus_damage = health_lost * damage_pct

	mod_table = {
		duration = duration,
	}
	mod = caster:AddNewModifier(caster, self, "modifier_satan_trade_attack", mod_table)
	mod:SetStackCount(bonus_damage)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	caster:EmitSound("Hero_DoomBringer.DevourCast")
end
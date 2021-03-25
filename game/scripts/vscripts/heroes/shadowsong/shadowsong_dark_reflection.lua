shadowsong_dark_reflection = class({})

local ability = shadowsong_dark_reflection

LinkLuaModifier( "modifier_shadowsong_dark_reflection_stun", "heroes/shadowsong/modifiers/modifier_shadowsong_dark_reflection_stun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shadowsong_dark_reflection_immune", "heroes/shadowsong/modifiers/modifier_shadowsong_dark_reflection_immune", LUA_MODIFIER_MOTION_NONE )

function ability:IsHiddenWhenStolen() return false end

function ability:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		return UF_SUCCESS
	end

	if not caster.HasTalent then return UF_FAIL_CUSTOM end
	if not caster:HasTalent("shadowsong_special_bonus_reflection_teammate") then return UF_FAIL_CUSTOM end

	return UF_SUCCESS
end

function ability:GetCustomCastErrorTarget(target)
    return "#dota_hud_error_cant_cast_on_ally"
end

function ability:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_sparkles_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_sparkles_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, target)

	return true
end

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local casterPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()

	local isEnemy = caster:GetTeamNumber() ~= target:GetTeamNumber()
	if isEnemy then
		target:TriggerSpellReflect(self)

		if target:TriggerSpellAbsorb(self) then
			return
		end
	end

	FindClearSpaceForUnit(caster, targetPos, false)
	FindClearSpaceForUnit(target, casterPos, false)

	ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN, target)


	if isEnemy then
		local stunDuration = self:GetSpecialValueFor("stun_duration")

		target:AddNewModifier(caster, self, "modifier_shadowsong_dark_reflection_stun", { duration = stunDuration })
	end

	local immuneDuration = caster:GetTalentSpecialValueFor("shadowsong_special_bonus_reflection_magic_immune")

	if immuneDuration ~= 0 then
		caster:AddNewModifier(caster, self, "modifier_shadowsong_dark_reflection_immune", { duration = immuneDuration })
	end

	caster:EmitSound("Hero_Antimage.Counterspell.Cast")
end
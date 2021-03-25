joe_black_song = class({})

LinkLuaModifier("modifier_joe_black_song_buff", "heroes/joeblack/modifiers/modifier_joe_black_song_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_joe_black_song_debuff", "heroes/joeblack/modifiers/modifier_joe_black_song_debuff", LUA_MODIFIER_MOTION_NONE)

function joe_black_song:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function joe_black_song:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeamNumber()
	local position = caster:GetAbsOrigin()

	caster.ult_targets = {}

	local radius = self:GetSpecialValueFor("radius")
	local particle_speed = 1200
	local duration = self:GetSpecialValueFor("duration")

	local talent_name = "joe_black_special_song"
	local talent_ability = caster:FindAbilityByName(talent_name)

	local units = FindUnitsInRadius(
		team, 
		position, 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)
	for _, unit in pairs(units) do
		if unit:GetTeamNumber() == team then
			if talent_ability and talent_ability:GetLevel() ~= 0 then
				unit:AddNewModifier(caster, self, "modifier_joe_black_song_buff", {duration = duration})
				table.insert(caster.ult_targets, unit)
			end
		else
			unit:AddNewModifier(caster, self, "modifier_joe_black_song_debuff", {duration = duration})
			table.insert(caster.ult_targets, unit)
		end
	end


	local particle_name = "particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf"

	local song_part = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( song_part, 0, position )
	ParticleManager:ReleaseParticleIndex(song_part)

	caster:EmitSound("Hero_QueenOfPain.SonicWave")
end
megacreep_energy_creature_buff = class({})

LinkLuaModifier( "modifier_megacreep_energy_creature_buff", 'creeps/abilities/megacreep_energy_creature/modifiers/modifier_megacreep_energy_creature_buff', LUA_MODIFIER_MOTION_NONE )

function megacreep_energy_creature_buff:IsHiddenWhenStolen() return false end

function megacreep_energy_creature_buff:OnSpellStart()
	local caster = self:GetCaster() 
	local pos	 = caster:GetAbsOrigin()
	local speed  = self:GetSpecialValueFor("speed")

	local radius = self:GetCastRange(pos, caster) + caster:GetCastRangeBonus()

	local allies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false) 
		
	local nResist = self:GetSpecialValueFor("resist_per_hero") * #allies

	local duration = self:GetDuration()

	for _, hTarget in pairs(allies) do
		hTarget:AddNewModifier(caster, self, "modifier_megacreep_energy_creature_buff", { resist = nResist, duration = duration})
	end

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Razor.UnstableCurrent.Target", caster)
end

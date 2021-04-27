abyssal_underlord_dark_rift = class({})
LinkLuaModifier("modifier_dark_rift_charges", "heroes/underlord/modifier_dark_rift_charges", LUA_MODIFIER_MOTION_NONE)

function abyssal_underlord_dark_rift:IsHiddenWhenStolen() return false end

function abyssal_underlord_dark_rift:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function abyssal_underlord_dark_rift:GetIntrinsicModifierName()
	return "modifier_dark_rift_charges"
end

function abyssal_underlord_dark_rift:CastFilterResultLocation(location)
	if self:GetCaster():HasScepter() and self.dark_rift_mod and not self.dark_rift_mod:IsNull() then
		if self.dark_rift_mod:GetStackCount() == 0 then
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end

function abyssal_underlord_dark_rift:GetCustomCastErrorLocation(location)
	return "#dota_hud_error_no_charges"
end

function abyssal_underlord_dark_rift:OnSpellStart()
	local caster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	local radius 		= self:GetSpecialValueFor("radius")
	local teleport_delay
	if caster:HasScepter() then
		teleport_delay	= self:GetSpecialValueFor("scepter_teleport_delay")
	else
		teleport_delay	= self:GetSpecialValueFor("teleport_delay")
	end

	local part_name 		= "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf"
	local point_part_name 	= "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf"

	caster:EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")
	EmitSoundOnLocationWithCaster(vPoint,"Hero_AbyssalUnderlord.DarkRift.Target", caster )

	local vPart_point = vPoint + Vector(0,0,100)
	local point_part = ParticleManager:CreateParticle(point_part_name, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( point_part, 0, vPart_point )
	ParticleManager:SetParticleControl( point_part, 1, vPart_point )
	ParticleManager:SetParticleControl( point_part, 2, vPart_point )
	ParticleManager:SetParticleControl( point_part, 3, vPart_point )
	ParticleManager:SetParticleControl( point_part, 5, vPart_point )
	ParticleManager:SetParticleControl( point_part, 20, vPart_point )

	local part = ParticleManager:CreateParticle(part_name, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(part, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(part, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControl( part, 1, Vector( radius, 1, 1 ) )

	Timers:CreateTimer(teleport_delay, function()
		ParticleManager:DestroyParticle( part, false)
		ParticleManager:DestroyParticle(point_part, false)
		caster:StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")

		if caster:IsAlive() then
			local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
			
			local pos = caster:GetAbsOrigin() 
			
			for _,ally in pairs(allies) do
				local diff = ally:GetAbsOrigin() - pos
				ally:SetAbsOrigin(vPoint + diff)
				FindClearSpaceForUnit(ally, vPoint + diff, true)
			end
			return nil
		end 
	end)

	if caster:HasScepter() then
		self.dark_rift_mod:SpendCharge()
	end
end
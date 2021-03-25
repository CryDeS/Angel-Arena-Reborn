enigma_demonic_conversion = class({})
LinkLuaModifier("modifier_eidolons_attack_counter","heroes/enigma/modifier_eidolons_attack_counter",LUA_MODIFIER_MOTION_NONE)

function enigma_demonic_conversion:IsHiddenWhenStolen() 		return false end

function enigma_demonic_conversion:OnSpellStart()
	local caster 		= self:GetCaster()
	local target 		= self:GetCursorTarget()
	local ability_level = self:GetLevel()
	local spawn_count 	= self:GetSpecialValueFor("spawn_count")
	local talent_ability = caster:FindAbilityByName("special_bonus_unique_enigma")

	if talent_ability and talent_ability:GetLevel() >= 1 then
		spawn_count = spawn_count + talent_ability:GetSpecialValueFor("value")
	end

	local pos
	local unit 

	if target and target:IsAlive() and target:IsCreep() then

		target:Kill(self, caster)
		
		pos = target:GetAbsOrigin()
	else 
		pos = self:GetCursorPosition() 
		unit = caster
	end

	caster:EmitSound("Hero_Enigma.Demonic_Conversion.Target")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf",  PATTACH_POINT_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, false)
	ParticleManager:SetParticleControl(particle, 1, pos)

	local unitname = "npc_eidolon_".. tostring(ability_level)

	--spawn eidolons
	for i = 1, spawn_count do
		local eidolon = CreateUnitByName(unitname,pos + RandomVector(100),true,caster,nil,caster:GetTeam())
		eidolon:SetControllableByPlayer(caster:GetPlayerID(),true)
		eidolon:SetOwner(caster)
		eidolon:AddNewModifier(caster, self, "modifier_demonic_conversion", { duration = self:GetDuration()} )
		eidolon:AddNewModifier(caster, self, "modifier_eidolons_attack_counter", { duration = self:GetDuration() })
		FindClearSpaceForUnit(eidolon, eidolon:GetOrigin(), true)
	end
end
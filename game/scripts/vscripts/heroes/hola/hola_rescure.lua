hola_rescure = class({})
LinkLuaModifier("modifier_hola_grace", "heroes/hola/modifier_hola_grace", LUA_MODIFIER_MOTION_NONE)

function hola_rescure:IsHiddenWhenStolen() 		return false end

function hola_rescure:OnSpellStart( ... )
	if not IsServer() then return end
	local caster 	= self:GetCaster()

	local radius 	= self:GetSpecialValueFor("radius")
	local duration 	= self:GetSpecialValueFor("duration")

	local talent_name = "hola_special_bonus_ultimate"

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	-- TODO: Sound 
	
	for _,ally in pairs(allies) do 
		ally:Purge(false, true, false, true, true)

		--because i can. WHOOP WHOOP WHOOP
		while(ally:HasModifier("modifier_huskar_burning_spear_counter")) do
			ally:RemoveModifierByName("modifier_huskar_burning_spear_counter")
		end
		ally:RemoveModifierByName("modifier_huskar_burning_spear_debuff")
		ally:RemoveModifierByName("modifier_dazzle_weave_armor")
		ally:RemoveModifierByName("modifier_dazzle_weave_armor_debuff")
		--
		ally:AddNewModifier(caster,self,"modifier_oracle_false_promise", {duration = duration})
		
		if caster:HasAbility(talent_name) and caster:FindAbilityByName(talent_name):GetLevel() ~= 0 then
			local heal_amount = caster:GetAbilityByIndex(1):GetSpecialValueFor("heal")
			ally:AddNewModifier(caster,self,"modifier_hola_grace", {duration = 2.5, heal = heal_amount})
		end
		
	end
end
small_satyr_big_clap = class({})

LinkLuaModifier( "modifier_small_satyr_big_clap_slow", "creeps/abilities/npc_aa_creep_small_satyr_big/modifier_small_satyr_big_clap_slow", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------------------
function small_satyr_big_clap:OnSpellStart()
    if not IsServer() then return end 

    local caster 			= self:GetCaster()
    local radius 			= self:GetSpecialValueFor("radius")
    local debuff_duration 	= self:GetSpecialValueFor("duration")
    local damage 			= self:GetSpecialValueFor("damage")

    local units = FindUnitsInRadius(caster:GetTeamNumber(), 
    								caster:GetAbsOrigin(), 
    								nil, 
    								radius, 
    								self:GetAbilityTargetTeam(), 
    								self:GetAbilityTargetType(), 
    								self:GetAbilityTargetFlags(), 
    								FIND_ANY_ORDER, 
    								false)



	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(pid, 0, caster:GetAbsOrigin())
	caster:EmitSound("Hero_Brewmaster.ThunderClap")

    if not units or #units == 0 then return end 

    for _, unit in pairs(units) do 
	   	ApplyDamage(
	    {
	    	victim = unit, 
	    	attacker = caster,
	    	damage = damage,
	    	damage_type = self:GetAbilityDamageType(),
	    	ability = self
	    })

	    unit:AddNewModifier(caster, self, "modifier_small_satyr_big_clap_slow", { duration = debuff_duration })
	end 
end
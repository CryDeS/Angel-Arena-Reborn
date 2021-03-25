abyss_warrior_domination = abyss_warrior_domination or class({})

local ability = abyss_warrior_domination

LinkLuaModifier( "modifier_abyss_warrior_domination", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_domination', LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_abyss_warrior_domination_debuff", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_domination_debuff', LUA_MODIFIER_MOTION_NONE )

function _makeParticle(unit)
	local pos = unit:GetAbsOrigin()

	local idx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_head_core.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

	ParticleManager:SetParticleControlEnt( idx, 3, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", pos, true)
end

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:TriggerSpellReflect(self)

	if target:TriggerSpellAbsorb(self) then 
		return 
	end

	target:AddNewModifier(caster, self, "modifier_abyss_warrior_domination", { duration = -1 })
	
	target:EmitSound("Hero_Warlock.Upheaval")
	
	_makeParticle(target)
	_makeParticle(caster)
end


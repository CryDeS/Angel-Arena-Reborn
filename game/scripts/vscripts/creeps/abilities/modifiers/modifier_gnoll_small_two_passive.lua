modifier_gnoll_small_two_passive = modifier_gnoll_small_two_passive or class({})
local mod = modifier_gnoll_small_two_passive

function mod:IsHidden() return true end
function mod:IsPurgable() return false end
function mod:DestroyOnExpire() return true end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.radius = ability:GetSpecialValueFor("radius")
	self.hp 	= ability:GetSpecialValueFor("heal_pct")
end

mod.OnRefresh = mod.OnCreated

if IsServer() then
	function mod:OnDeath( kv )
		local caster = self:GetParent()

		if caster ~= kv.unit then 
			return 
		end 

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false) 

		for _, unit in pairs(units) do
			unit:Heal(unit:GetMaxHealth() * self.hp / 100, caster )

			local fx = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonlight_shaft03_ti_5_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:SetParticleControl(fx, 0, unit:GetAbsOrigin() )
		end 
	end

	function mod:DeclareFunctions()
		return {  MODIFIER_EVENT_ON_DEATH, }
	end
end
modifier_abyss_warrior_ethereal_charge = modifier_abyss_warrior_ethereal_charge or class({})

local mod = modifier_abyss_warrior_ethereal_charge

function mod:IsHidden()         return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire()  return true end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.hpRegenPct = ability:GetSpecialValueFor("hp_regen_pct")
	self.heal = 0

	if IsServer() then
		self.health = self:GetParent():GetHealth()
	end
end

mod.OnRefresh = mod.OnCreated

function _OnHealUnit(unit, ammount)
	local unitPos = unit:GetAbsOrigin()

	local idx = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

	ParticleManager:SetParticleControlEnt( idx, 4, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", unitPos, true)

	local idx2 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)

	ParticleManager:SetParticleControlEnt( idx, 0, unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", unitPos, true)

	SendOverheadEventMessage(unit, OVERHEAD_ALERT_HEAL, unit, ammount, nil)

	unit:EmitSound("Hero_Warlock.ShadowWordCastGood")
end

function mod:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()

	local heal = self.heal

	if heal ~= 0 and parent then
		parent:Heal( heal, parent )
		_OnHealUnit( parent, heal )
		self.heal = 0
	end

	self.health = nil

	local ability = self:GetAbility()

	if not ability then return end

	local stunDuration = ability:GetSpecialValueFor("stun_duration")
	local stunRadius   = ability:GetSpecialValueFor("stun_aoe")


	local units = FindUnitsInRadius( parent:GetTeamNumber(),
									 parent:GetAbsOrigin(),
									 parent,
									 stunRadius,
									 ability:GetAbilityTargetTeam(),
									 ability:GetAbilityTargetType(),
									 ability:GetAbilityTargetFlags(),
									 FIND_ANY_ORDER, 
									 false )

	parent:EmitSound("Hero_WarlockGolem.PreAttack")

	for _, unit in pairs(units) do
		unit:AddNewModifier(parent, ability, "modifier_abyss_warrior_ethereal_charge_stun", { duration = stunDuration })

		local idx = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)

		ParticleManager:SetParticleControlEnt( idx, 3, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	end
end


function mod:DeclareFunctions() return 
{ 
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
} 
end


function mod:CheckState() return
{
	[MODIFIER_STATE_STUNNED] = true,
}
end

function mod:GetModifierHealthRegenPercentage()
	return self.hpRegenPct
end

function mod:OnTakeDamage( params )
	if not IsServer() then return end

	local parent = params.unit

	if parent ~= self:GetParent() then return end

	if not parent or parent:IsNull() then return end
	
	local damage = params.damage

	self.heal = self.heal + damage

	if self.health ~= nil then
		parent:SetHealth( self.health )
	end

	_OnHealUnit( parent, self.heal )
end

function mod:GetEffectName()
	return "particles/econ/items/dragon_knight/dk_ti8_awakening/dk_ti8_awakening_dragon_2_ambient_gem_top_base.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function mod:GetOverrideAnimation(params)
	return ACT_DOTA_TELEPORT
end
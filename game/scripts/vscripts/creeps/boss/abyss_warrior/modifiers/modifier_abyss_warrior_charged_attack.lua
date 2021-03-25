modifier_abyss_warrior_charged_attack = modifier_abyss_warrior_charged_attack or class({})

local mod = modifier_abyss_warrior_charged_attack

function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.radius 		= ability:GetSpecialValueFor("radius")
	self.damage 		= ability:GetSpecialValueFor("damage")
	self.stunDuration 	= ability:GetSpecialValueFor("stun_duration")
	self.blockDuration  = ability:GetSpecialValueFor("spellblock_duration")
end

function _IsReady(ability)
	if not IsServer() then return false end

	if not ability then return false end

	return ability:GetCooldownTimeRemaining() == 0
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function _makeParticle(from, fromPos, to)
	local idx = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, from)

	ParticleManager:SetParticleControlEnt( idx, 0, from, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", from:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt( idx, 1, to, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", to:GetAbsOrigin(), true)
end

function mod:OnAttackLanded( kv )
	if not IsServer() then return end 

	local parent = self:GetParent()

	if not parent then return end

	if parent:PassivesDisabled() then return end

	if parent ~= kv.attacker then return end

	local ability = self:GetAbility()

	if not _IsReady( ability ) then return end

	local target = kv.target

	local targetPos = target:GetAbsOrigin()

	ability:StartCooldown( ability:GetCooldown( ability:GetLevel() - 1 ) )

	target:EmitSound("Hero_Warlock.RainOfChaos")

	local enemies = FindUnitsInRadius( 	parent:GetTeamNumber(), 
										targetPos, 
										nil, 
										self.radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										0,
										0, 
										false )

	ParticleManager:CreateParticle(	"particles/econ/wards/warlock/ward_warlock/warlock_ambient_ward_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, target)

	for _, enemy in pairs(enemies) do
		_makeParticle( target, targetPos, enemy )

		enemy:AddNewModifier(parent, ability, "modifier_abyss_warrior_charged_attack_stun", { duration = self.stunDuration })
	end

	local nEnemies  = #enemies

	if nEnemies ~= 0 then
		parent:AddNewModifier(parent, ability, "modifier_abyss_warrior_charged_attack_linken", { duration = self.blockDuration }):SetStackCount( nEnemies )
	end
end

function mod:GetModifierPreAttack_BonusDamage()
	if not _IsReady( self:GetAbility() ) then return 0 end

	local parent = self:GetParent()

	if not parent then return end

	if parent:PassivesDisabled() then return end
	
	return self.damage
end
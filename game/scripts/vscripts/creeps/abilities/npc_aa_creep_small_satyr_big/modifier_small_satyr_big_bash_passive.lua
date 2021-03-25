modifier_small_satyr_big_bash_passive = modifier_small_satyr_big_bash_passive or class({})
local mod = modifier_small_satyr_big_bash_passive

function mod:IsHidden() return true end
function mod:DestroyOnExpire() return true end
function mod:IsPurgable() return false end

function mod:OnCreated()
	if not IsServer() then return end 

	local ability = self:GetAbility()

	if not ability then return end

	self.bashChance = ability:GetSpecialValueFor("chance")
	self.duration = ability:GetSpecialValueFor("duration")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACKED,
}
end

function mod:OnAttacked( params )
	if not IsServer() then return end 

	if self:GetParent() ~= params.attacker then
		return
	end

	local ability = self:GetAbility()
	local caster = self:GetCaster() 
	local target = params.target

	if not caster then caster = params.attacker; end 

	if caster:PassivesDisabled() then return end 
	if target:IsMagicImmune() then return end 

	if RollPercentage(self.bashChance) then 
		target:AddNewModifier(caster, ability, "modifier_small_satyr_big_bash_stunned", { duration = self.duration })
	end 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash_hit.vpcf",  PATTACH_POINT_FOLLOW, target)

	ParticleManager:SetParticleControlEnt(particle, 0, target,  PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)

	target:EmitSound("DOTA_Item.SkullBasher") -- sounds/items/skull_basher.vsnd -- soundevents/game_sounds_items.vsndevts

	return 0
end
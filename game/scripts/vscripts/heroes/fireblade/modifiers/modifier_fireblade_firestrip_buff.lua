modifier_fireblade_firestrip_buff = modifier_fireblade_firestrip_buff or class({})
local mod = modifier_fireblade_firestrip_buff

function mod:IsHidden() 		return false end
function mod:IsDebuff() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true  end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
	end

	local parent = self:GetParent()

	local particle = ParticleManager:CreateParticle( "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )

	ParticleManager:SetParticleControlEnt(particle, 1, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), false)

	self.particle = particle

	self.resist = ability:GetSpecialValueFor("damage_resist_per_hero")
end

function mod:OnDestroy( kv )
	local idx = self.particle

	if idx then
		ParticleManager:DestroyParticle(idx, false)
		self.particle = nil
	end
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function mod:GetModifierIncomingDamage_Percentage()
	return -self.resist * self:GetStackCount()
end
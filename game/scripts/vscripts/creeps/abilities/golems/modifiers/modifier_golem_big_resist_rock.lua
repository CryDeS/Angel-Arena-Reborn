modifier_golem_big_resist_rock = modifier_golem_big_resist_rock or class({})

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:OnCreated()
	local ability = self:GetAbility() 

	if ability then
		self.hp_regen = ability:GetSpecialValueFor("regen_health")
		self.block_damage = ability:GetSpecialValueFor("resist")
	else 
		self.hp_regen = 0
		self.block_damage = 0
	end 
end

--------------------------------------------------------------------------------


function modifier_golem_big_resist_rock:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:CheckState() return 
{ 
	[MODIFIER_STATE_FROZEN] = true, 
	[MODIFIER_STATE_STUNNED] = true, 
} 
end

--------------------------------------------------------------------------------

function modifier_golem_big_resist_rock:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_golem_big_resist_rock:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_golem_big_resist_rock:GetModifierHealthRegenPercentage() return self.hp_regen end
function modifier_golem_big_resist_rock:GetModifierIncomingDamage_Percentage() return -self.block_damage end


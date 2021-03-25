modifier_npc_aa_creep_salamander_small_damage_aura_effect_lua = modifier_npc_aa_creep_salamander_small_damage_aura_effect_lua or class({})
local mod = modifier_npc_aa_creep_salamander_small_damage_aura_effect_lua

function mod:IsHidden() return true end

function mod:IsDebuff() return false end

function mod:OnCreated( kv )
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function mod:GetModifierPreAttack_BonusDamage ( params )
	if not self or self:IsNull() then return 0 end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return 0 end

	if parent:PassivesDisabled() then return 0 end
	 
	return self.bonus_dmg or 0
end
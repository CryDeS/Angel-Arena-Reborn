modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.bonus_hp = ability:GetSpecialValueFor( "bonus_hp" )
end

modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua.OnRefresh = modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua.OnCreated

function modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_salamander_big_hp_aura_effect_lua:GetModifierHealthBonus ( params )
	local caster = self:GetCaster()
	if caster and caster:PassivesDisabled() then
		return 0
	end
	return self.bonus_hp or 0
end

-------------------------------------------------------------------------------
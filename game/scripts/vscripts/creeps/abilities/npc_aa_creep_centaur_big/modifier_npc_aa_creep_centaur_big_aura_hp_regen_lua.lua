modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua = class({})

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:GetModifierAura()
	return "modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua"
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------
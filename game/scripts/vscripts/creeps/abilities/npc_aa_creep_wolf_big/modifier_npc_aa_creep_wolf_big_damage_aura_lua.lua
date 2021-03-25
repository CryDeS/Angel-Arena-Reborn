modifier_npc_aa_creep_wolf_big_damage_aura_lua = class({})

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:GetModifierAura()
	return "modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:GetAuraRadius()
	return self.radius or 0
end

--------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_damage_aura_lua:OnCreated( kv )
	local ability = self:GetAbility() 
	if not ability then return end

	self.radius = ability:GetSpecialValueFor( "radius" )
end

modifier_npc_aa_creep_wolf_big_damage_aura_lua.OnRefresh = modifier_npc_aa_creep_wolf_big_damage_aura_lua.OnCreated

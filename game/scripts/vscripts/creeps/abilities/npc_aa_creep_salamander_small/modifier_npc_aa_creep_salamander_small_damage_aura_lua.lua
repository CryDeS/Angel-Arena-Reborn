modifier_npc_aa_creep_salamander_small_damage_aura_lua = modifier_npc_aa_creep_salamander_small_damage_aura_lua or class({})
local mod = modifier_npc_aa_creep_salamander_small_damage_aura_lua

function mod:IsAura() return true end

function mod:IsHidden() return false end

function mod:GetModifierAura() return "modifier_npc_aa_creep_salamander_small_damage_aura_effect_lua" end

function mod:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function mod:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end

function mod:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function mod:GetAuraRadius() return self.radius or 0 end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.radius = ability:GetSpecialValueFor( "radius" )
end

mod.OnRefresh = mod.OnCreated
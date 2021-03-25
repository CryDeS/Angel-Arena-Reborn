modifier_spiked_armor_aura_enemy_emitter = class({})
--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:GetModifierAura()
    return "modifier_spiked_armor_aura_enemy"
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:GetAuraRadius()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("enemy_radius")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy_emitter:OnCreated( kv )

end

function modifier_spiked_armor_aura_enemy_emitter:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end
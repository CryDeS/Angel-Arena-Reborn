modifier_amaliels_cuirass = class({})
--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:DestroyOnExpire()
	return false
end

function modifier_amaliels_cuirass:OnDestroy()
    if IsServer() then
        if self.modifier and not self.modifier:IsNull() then
            self.modifier:Destroy()
        end
    end
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierAura()
    return "modifier_amaliels_cuirass_aura_friend"
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetAuraRadius()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("friend_radius")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:OnCreated( kv )
    if IsServer() then
        local caster = self:GetCaster() 
        local ability = self:GetAbility()

        self.modifier = caster:AddNewModifier(caster, ability, "modifier_amaliels_cuirass_enemy_emitter", {})
        print(self.modifier, caster, ability)
    end
end

function modifier_amaliels_cuirass:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_armor")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierAttackSpeedBonus_Constant()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_aspeed")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierHealthBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_health")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierBonusStats_Strength()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierBonusStats_Agility()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:GetModifierBonusStats_Intellect()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_HEALTH_BONUS, -- GetModifierHealthBonus
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, -- GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, -- GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, -- GetModifierBonusStats_Intellect
	}

	return funcs
end

--------------------------------------------------------------------------------
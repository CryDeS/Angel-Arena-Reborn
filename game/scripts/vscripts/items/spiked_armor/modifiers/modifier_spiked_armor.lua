modifier_spiked_armor = class({})
--------------------------------------------------------------------------------

function modifier_spiked_armor:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:DestroyOnExpire()
	return false
end

function modifier_spiked_armor:OnDestroy()
    if IsServer() then
        if self.modifier and not self.modifier:IsNull() then
            self.modifier:Destroy()
            print("VALID print.Modifier destroy ")
        else
            print("NOT VALID print.Modifier")
        end

    end
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierAura()
    return "modifier_spiked_armor_aura_friend"
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetAuraRadius()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("friend_radius")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:OnCreated( kv )
    if IsServer() then
        local caster = self:GetCaster() 
        local ability = self:GetAbility()

        self.modifier = caster:AddNewModifier(caster, ability, "modifier_spiked_armor_aura_enemy_emitter", {})
        print(self.modifier, caster, ability)
    end
end

function modifier_spiked_armor:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_armor")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierAttackSpeedBonus_Constant()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_aspeed")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierHealthBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_health")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierBonusStats_Strength()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierBonusStats_Agility()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:GetModifierBonusStats_Intellect()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_stats")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor:DeclareFunctions()
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
--[[
local return_damage = 200 / 100 -- 200%

function modifier_spiked_armor:OnTakeDamage( params )
	if IsServer() then
        if params.unit ~= self:GetParent() then
        	return
        end

        if testflag(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then return end 

        ApplyDamage({
            victim = params.attacker,
            attacker = params.unit,
            damage = params.damage * return_damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
        })

	end
	return 0
end

function testflag(set, flag)
  return set % (2*flag) >= flag
end
]]
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
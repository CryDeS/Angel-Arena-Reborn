modifier_summon_eidolon = class({})

function modifier_summon_eidolon:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_summon_eidolon:IsHidden()
    return true
end

function modifier_summon_eidolon:IsPurgable()
    return false
end

function modifier_summon_eidolon:GetModifierExtraHealthBonus(params)
    local time = GameRules:GetGameTime() / 60
    if time > 20 then
        return max(1.7143 * math.pow(time, 2) - 37.1429 * time, 0)
    else
        return 0
    end
end

function modifier_summon_eidolon:GetModifierBaseAttack_BonusDamage(params)
    local time = GameRules:GetGameTime() / 60
    if time > 20 then
        return -0.0250*math.pow(time, 2)+10.5500*(time) - 167.0000
    else
        return 0
    end
end

function modifier_summon_eidolon:GetModifierPhysicalArmorBonus(params)
    local time = GameRules:GetGameTime() / 60
    local armor = math.pow(math.sqrt(time - 15), (2.718*0.88))

    if time < 15 then armor = 0 end -- caused by sqrt(-15)

    return armor
end

function modifier_summon_eidolon:OnCreated(event)
end
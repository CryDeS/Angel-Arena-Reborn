modifier_summon_plague_ward = class({})

function modifier_summon_plague_ward:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_summon_plague_ward:IsHidden()
    return true
end

function modifier_summon_plague_ward:IsPurgable()
    return false
end

function modifier_summon_plague_ward:GetModifierExtraHealthBonus(params)
    local time = GameRules:GetGameTime() / 60
    if time > 20 then
        return 0.0714 * math.pow(time, 2) + 16.2857 * time - 240.0000
    else
        return 0
    end
end

function modifier_summon_plague_ward:GetModifierBaseAttack_BonusDamage(params)
    local time = GameRules:GetGameTime() / 60
    if time > 20 then
        return 0.0214 * math.pow(time, 2) + 3.1857 * time - 44.0000
    else
        return 0
    end
end

function modifier_summon_plague_ward:GetModifierPhysicalArmorBonus(params)
    local time = GameRules:GetGameTime()
    if time > 1200 then
        return 0.0105 * time - 5.400
    else
        return 0
    end
end

function modifier_summon_plague_ward:OnCreated(event)
end
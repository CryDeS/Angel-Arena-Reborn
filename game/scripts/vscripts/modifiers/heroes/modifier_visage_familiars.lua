modifier_visage_familiars = class({})

function modifier_visage_familiars:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_visage_familiars:OnCreated()
    if not IsServer() then return end
    
    local me = self:GetParent()
    local wantHp = self:GetModifierExtraHealthBonus()

    local totalHP = me:GetMaxHealth()  + wantHp

    me:SetBaseMaxHealth(totalHP)
    me:SetMaxHealth(totalHP)
    me:SetHealth(totalHP)
end

function modifier_visage_familiars:IsHidden()
    return true
end

function modifier_visage_familiars:IsPurgable()
    return false
end

function modifier_visage_familiars:GetModifierBaseAttack_BonusDamage(params)
    local time = GameRules:GetGameTime()

    local res = time / 20 - time / 150

    if res < 0 then return 0 end

    return max(res, 0)
end


function modifier_visage_familiars:GetModifierExtraHealthBonus(params)
    local time = GameRules:GetGameTime()
        
    local res = 1.0 * time - 5 * math.sqrt(time)

	if res < 0 then return 0 end

    return max(res, 0)
end

function modifier_visage_familiars:GetModifierPhysicalArmorBonus(params)
    local time = GameRules:GetGameTime()

    local res = 0.7 * (time / 100) - (1000 / time)

    if res < 0 then return 0 end
    
    return max(res, 0)
end
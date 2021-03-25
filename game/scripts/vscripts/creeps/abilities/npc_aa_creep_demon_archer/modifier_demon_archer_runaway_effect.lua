modifier_demon_archer_runaway_effect = class({})

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:OnCreated(kv)
        self.bonus_movespeed = kv.bonus_movespeed
end

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_demon_archer_runaway_effect:GetModifierMoveSpeedBonus_Constant(params)
    if self:GetParent():PassivesDisabled() then return 0 end
    local net_table = CustomNetTables:GetTableValue("heroes", "skills_modifiers") or {}
    local unicalUnitString = tostring(self:GetParent():entindex())
    local bonus_speed
    if not IsServer() then
        bonus_speed = net_table[unicalUnitString .. "_bonusspeedarcher"]
    else
        bonus_speed = self.bonus_movespeed
        net_table[unicalUnitString .. "_bonusspeedarcher"] = bonus_speed
        CustomNetTables:SetTableValue("heroes", "skills_modifiers", net_table)
    end
    return bonus_speed or 0
end

--------------------------------------------------------------------------------


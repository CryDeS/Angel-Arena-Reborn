modifier_creep_warrior_hulk_effect_lua = class({})

-------------------------------------------------------------------------------
function modifier_creep_warrior_hulk_effect_lua:IsHidden()
    return false
end

-------------------------------------------------------------------------------
function modifier_creep_warrior_hulk_effect_lua:IsDebuff()
    return false
end
-------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:IsSilenced()
    return true
end
-------------------------------------------------------------------------------
function modifier_creep_warrior_hulk_effect_lua:OnCreated( kv )
    self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
    self.disarmor = self:GetAbility():GetSpecialValueFor("disarmor")
end
-------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:GetEffectName()
    return "particles/generic_gameplay/generic_silenced.vpcf"
end

--------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }
    return state
end

--------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:GetModifierPhysicalArmorBonus(params)
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return -(self.disarmor)
end

-------------------------------------------------------------------------------

function modifier_creep_warrior_hulk_effect_lua:GetModifierBaseDamageOutgoing_Percentage(params)
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self.damage_pct
end

-------------------------------------------------------------------------------
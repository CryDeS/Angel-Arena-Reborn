modifier_demon_archer_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_demon_archer_aura_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_demon_archer_aura_effect:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura_effect:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_demon_archer_aura_effect:OnCreated( kv )
    if self:GetAbility() then
        self.bonus_damage_for_range_hero = self:GetAbility():GetSpecialValueFor( "bonus_damage_for_range_hero" )
    end
end

modifier_demon_archer_aura_effect.OnRefresh = modifier_demon_archer_aura_effect.OnCreated
--------------------------------------------------------------------------------

function modifier_demon_archer_aura_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_demon_archer_aura_effect:GetModifierBaseDamageOutgoing_Percentage( params )
    local parent = self:GetCaster()

    if not parent or parent:IsNull() and parent:PassivesDisabled() then
        return 0
    end
    
    return self.bonus_damage_for_range_hero or 0
end

--------------------------------------------------------------------------------
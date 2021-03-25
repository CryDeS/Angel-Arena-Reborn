modifier_throwing_daggers = class({})
--------------------------------------------------------------------------------

function modifier_throwing_daggers:IsHidden() return true end
function modifier_throwing_daggers:IsPurgable() return false end
function modifier_throwing_daggers:DestroyOnExpire() return false end

--------------------------------------------------------------------------------

function modifier_throwing_daggers:OnCreated( kv )
    self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_throwing_daggers:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_throwing_daggers:DeclareFunctions() return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

--------------------------------------------------------------------------------

function modifier_throwing_daggers:GetModifierAttackSpeedBonus_Constant( params )
    local mult = 0

    local ability = self:GetAbility()

    if ability then 
        mult = ability:GetCurrentCharges()
    end

	return self.bonus_as * mult
end
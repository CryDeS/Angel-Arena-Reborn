modifier_fervor_aa_effect = class({})

--------------------------------------------------------------------------------

function modifier_fervor_aa_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_aa_effect:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_fervor_aa_effect:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_aa_effect:IsDebuff()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_aa_effect:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

--------------------------------------------------------------------------------
function modifier_fervor_aa_effect:OnRefresh(kv)
	self:OnCreated(kv)
end
-------------------------------------------------------------------------------

function modifier_fervor_aa_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_fervor_aa_effect:GetModifierPreAttack_BonusDamage( params )
    return self.damage * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_fervor_aa_effect:GetModifierAttackSpeedBonus_Constant( params )
	local attack_speed_by_talent = self:GetCaster():GetTalentSpecialValueFor("special_bonus_unique_troll_warlord_5")
    return (self.attack_speed + attack_speed_by_talent) * self:GetStackCount()
end

--------------------------------------------------------------------------------

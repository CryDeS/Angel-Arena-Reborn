modifier_ancient_satyr_big_passive_slow = class({})

--------------------------------------------------------------------------------

-- TODO: Texture 
function modifier_ancient_satyr_big_passive_slow:IsPurgable() return true end
function modifier_ancient_satyr_big_passive_slow:IsHidden() return false end
function modifier_ancient_satyr_big_passive_slow:IsDebuff() return true end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_passive_slow:OnCreated( kv )
    self.aspeed_slow = self:GetAbility():GetSpecialValueFor( "aspeed_slow" )
end


--------------------------------------------------------------------------------


function modifier_ancient_satyr_big_passive_slow:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_big_passive_slow:GetModifierAttackSpeedBonus_Constant( params )
    return -self.aspeed_slow
end

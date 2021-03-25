modifier_creep_warrior_block_lua = class({})

-------------------------------------------------------------------------------
function modifier_creep_warrior_block_lua:IsHidden()
    return false
end
-------------------------------------------------------------------------------
function modifier_creep_warrior_block_lua:OnCreated( kv )
    self.block = self:GetAbility():GetSpecialValueFor( "block" )
end
-------------------------------------------------------------------------------

function modifier_creep_warrior_block_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    }
    return funcs
end

-------------------------------------------------------------------------------

function modifier_creep_warrior_block_lua:GetModifierPhysical_ConstantBlock(params)
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self.block
end

-------------------------------------------------------------------------------
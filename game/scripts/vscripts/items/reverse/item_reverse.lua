item_reverse = class({})
LinkLuaModifier("modifier_item_reverse", 'items/reverse/modifier_item_reverse', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_reverse_active", 'items/reverse/modifier_item_reverse_active', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_reverse:GetIntrinsicModifierName()
    return "modifier_item_reverse"
end

function item_reverse:OnSpellStart()
    local duration = self:GetSpecialValueFor("phase_duration")
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_item_reverse_active", { duration = duration })
end

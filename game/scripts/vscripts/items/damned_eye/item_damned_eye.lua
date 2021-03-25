item_damned_eye = class({})
LinkLuaModifier("modifier_damned_eye", 'items/damned_eye/modifier_damned_eye', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damned_eye_active", 'items/damned_eye/modifier_damned_eye_active', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_damned_eye:GetIntrinsicModifierName()
    return "modifier_damned_eye"
end

function item_damned_eye:OnSpellStart()
    local duration = self:GetSpecialValueFor("time_to_heal") + 0.1
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_damned_eye_active", { duration = duration })
end

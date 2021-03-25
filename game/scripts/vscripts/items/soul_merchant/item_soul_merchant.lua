item_soul_merchant = item_soul_merchant or class({})

LinkLuaModifier("modifier_soul_merchant_passive", 'items/soul_merchant/modifier_soul_merchant_passive', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_merchant_active_buff_friendly", 'items/soul_merchant/modifier_soul_merchant_active_buff_friendly', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_merchant_active_buff_enemy", 'items/soul_merchant/modifier_soul_merchant_active_buff_enemy', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_soul_merchant:GetIntrinsicModifierName()
    return "modifier_soul_merchant_passive"
end

--------------------------------------------------------------------------------
function item_soul_merchant:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end

    self.duration_debuff = self:GetSpecialValueFor("duration_debuff")

    if target:HasModifier("modifier_soul_merchant_active_buff_enemy") then
        target:RemoveModifierByName("modifier_soul_merchant_active_buff_enemy")
    end
    target:AddNewModifier(caster, self, "modifier_soul_merchant_active_buff_enemy", { duration = self.duration_debuff })
    caster:AddNewModifier(caster, self, "modifier_soul_merchant_active_buff_friendly", { duration = self.duration_debuff })
end

--------------------------------------------------------------------------------

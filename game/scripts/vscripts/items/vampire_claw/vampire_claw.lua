item_vampire_claw = class({})
LinkLuaModifier("modifier_item_vampire_claw", 'items/vampire_claw/modifier_item_vampire_claw', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function item_vampire_claw:GetIntrinsicModifierName()
    return "modifier_item_vampire_claw"
end
--------------------------------------------------------------------------------
function item_vampire_claw:OnSpellStart()
    local charges = self:GetCurrentCharges()
    if charges <= 0 then return end
    local healPerCharge = self:GetSpecialValueFor("heal_per_charge")
    local heal = charges*healPerCharge
    self:GetCaster():Heal(heal, self)
    self:SetCurrentCharges(0)
    local caster = self:GetCaster()

    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal, nil)

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
end
--------------------------------------------------------------------------------
function item_vampire_claw:GetAbilityTextureName()
    local charges = self:GetCurrentCharges()
    if charges < 5 then
        return "vampire_claw_1"
    elseif charges < 10 then
        return "vampire_claw_2"
    elseif charges < 15 then
        return "vampire_claw_3"
    else
        return "vampire_claw_4"
    end
end
--------------------------------------------------------------------------------
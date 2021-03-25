modifier_npc_aa_creep_centaur_small_disarmor_effect_lua = modifier_npc_aa_creep_centaur_small_disarmor_effect_lua or class({})
local mod = modifier_npc_aa_creep_centaur_small_disarmor_effect_lua

function mod:IsHidden()
    return false
end

function mod:DestroyOnExpire()
    return true
end

function mod:IsDebuff()
    return true
end

function mod:OnCreated( kv )
    local ability = self:GetAbility()

    if not ability then return end

    self.disarmor_per_stack = ability:GetSpecialValueFor( "disarmor_per_stack" )
end

mod.OnRefresh = mod.OnCreated

function mod:GetEffectName()
    return "particles/disarmor/disarmor.vpcf"
end

function mod:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function mod:GetModifierPhysicalArmorBonus( params )
    return -( (self.disarmor_per_stack or 0) * self:GetStackCount())
end
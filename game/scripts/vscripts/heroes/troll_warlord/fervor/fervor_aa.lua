fervor_aa = class({})

LinkLuaModifier("modifier_fervor_aa", 'heroes/troll_warlord/fervor/modifier_fervor_aa', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fervor_aa_effect", 'heroes/troll_warlord/fervor/modifier_fervor_aa_effect', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function fervor_aa:GetIntrinsicModifierName()
    return "modifier_fervor_aa"
end
--------------------------------------------------------------------------------
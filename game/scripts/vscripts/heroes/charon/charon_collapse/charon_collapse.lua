charon_collapse = charon_collapse or class({})
LinkLuaModifier("modifier_charon_collapse_outside", "heroes/charon/charon_collapse/modifier_charon_collapse_outside", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_charon_collapse_inside", "heroes/charon/charon_collapse/modifier_charon_collapse_inside", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_charon_collapse_in_caster", "heroes/charon/charon_collapse/modifier_charon_collapse_in_caster", LUA_MODIFIER_MOTION_NONE)

function charon_collapse:OnSpellStart()
    local duration_full = self:GetSpecialValueFor("duration_inside")
    local caster = self:GetCaster()

    self.all_mana_drain = 0

    if IsServer() then
        if caster:HasTalent("charon_collapse_bonus_duration_tallent") then
            duration_full = duration_full + caster:GetTalentSpecialValueFor("charon_collapse_bonus_duration_tallent")
        end
    end

    caster:AddNewModifier(caster, self, "modifier_charon_collapse_in_caster", { duration = duration_full })
end

function charon_collapse:GetCastRange()
    return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentSpecialValueFor("charon_collapse_bonus_radius_tallent")
end

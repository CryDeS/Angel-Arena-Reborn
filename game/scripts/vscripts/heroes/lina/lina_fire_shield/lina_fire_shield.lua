lina_fire_shield = class({})
LinkLuaModifier("modifier_lina_fire_shield", "heroes/lina/lina_fire_shield/modifier_lina_fire_shield", LUA_MODIFIER_MOTION_NONE)

-----------------------------------------------------------------------------
function lina_fire_shield:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local talentName = "lina_special_bonus_fire_shield"
    if talentName and caster:HasTalent(talentName) then
        duration = duration+caster:GetTalentSpecialValueFor(talentName)
    end
    caster:AddNewModifier(caster, self, "modifier_lina_fire_shield", { duration = duration })
end

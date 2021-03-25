troll_warlord_battle_trance = class({})
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom", "heroes/troll_warlord/modifier_troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function troll_warlord_battle_trance:OnSpellStart()
    local radius = 99999
    local duration = self:GetSpecialValueFor("trance_duration")
    local alliens = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    if #alliens > 0 then
        for _, friend in pairs(alliens) do
            if friend ~= nil and friend:IsRealHero() then
                friend:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom", { duration = duration })
            end
        end
    end
    local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord_4")
    local has_talent = (talent_ability and talent_ability:GetLevel() ~= 0)
    if has_talent then
        self:GetCaster():Purge(false, true, false, true, false )
    end

end

--------------------------------------------------------------------------------
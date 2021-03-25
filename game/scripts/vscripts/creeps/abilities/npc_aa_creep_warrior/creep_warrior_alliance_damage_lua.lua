creep_warrior_alliance_damage_lua = class({})
LinkLuaModifier("modifier_creep_warrior_alliance_damage_lua", "creeps/abilities/npc_aa_creep_warrior/modifier_creep_warrior_alliance_damage_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function creep_warrior_alliance_damage_lua:OnSpellStart()
    self.durability = self:GetSpecialValueFor("durability")
    self.damage_per_unit = self:GetSpecialValueFor("damage_per_unit")
    self.radius = self:GetSpecialValueFor("radius")
    self.allUnits = 0
    local team = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
    if team then
        self.allUnits = #team
    end
    if self.allUnits > 1 then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creep_warrior_alliance_damage_lua", { duration = self.durability, damage_per_unit = self.damage_per_unit })
        self:GetCaster():SetModifierStackCount("modifier_creep_warrior_alliance_damage_lua", self:GetCaster(), (self.allUnits - 1) * self.damage_per_unit)
    end
end

--------------------------------------------------------------------------------
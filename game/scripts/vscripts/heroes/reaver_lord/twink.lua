reaver_lord_twink = class({})
-----------------------------------------------------------------------------
function reaver_lord_twink:OnSpellStart()
    self.caster = self:GetCaster()
    local caster_point = self.caster:GetAbsOrigin()
    local target_point = self:GetCursorPosition()
    self.range = self:GetSpecialValueFor("range")
    local base = self.range
    local talentName = "reaver_lord_special_bonus_blink_range"
    if talentName and self.caster:HasTalent(talentName) then
        base = base + 800 --TODO сделать автоподтяжку из таланта
    end

    ProjectileManager:ProjectileDodge(self.caster)
    ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_mirror_image_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)

    local talent = self.caster:FindAbilityByName("reaver_lord_special_bonus_blink_range")
    if self:GetCaster():HasTalent(talentName) then
        self.range = self.range + talent:GetSpecialValueFor("value")
    end
    local length = (target_point - caster_point):Length2D()

    local total_point = target_point

    if length > self.range then
        total_point = caster_point + (target_point - caster_point):Normalized() * self.range
    end

    FindClearSpaceForUnit(self.caster, total_point, false)

    ProjectileManager:ProjectileDodge(self.caster)


    ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_mirror_image_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)

    EmitSoundOnLocationWithCaster(caster_point, "Hero_Antimage.Blink_out", self.caster)
    EmitSoundOnLocationWithCaster(caster_point, "Hero_PhantomAssassin.Strike.Start", self.caster)
end

-----------------------------------------------------------------------------
function reaver_lord_twink:GetCastRange()
    local range
    local caster = self:GetCaster()
    local net_table = CustomNetTables:GetTableValue("heroes", "reaver_lord_twink") or {}
    local unicalUnitString = tostring(caster:entindex())

    if not IsServer() then
        range = net_table[unicalUnitString .. "_reaver_lord_twink_range"]
    else
        local talentName = "reaver_lord_special_bonus_blink_range"
        if self:GetCaster():HasTalent(talentName) then
            range = self:GetSpecialValueFor("range") + caster:GetTalentSpecialValueFor(talentName)
        else
            range = self:GetSpecialValueFor("range")
        end
        net_table[unicalUnitString .. "_reaver_lord_twink_range"] = range
        CustomNetTables:SetTableValue("heroes", "reaver_lord_twink", net_table)
        return 99999
    end
    return range
end

-----------------------------------------------------------------------------
function reaver_lord_twink:IsHiddenWhenStolen()
    return false
end

-----------------------------------------------------------------------------
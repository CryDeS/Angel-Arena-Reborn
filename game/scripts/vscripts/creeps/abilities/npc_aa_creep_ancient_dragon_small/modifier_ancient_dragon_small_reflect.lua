modifier_ancient_dragon_small_reflect = class({})
-----------------------------------------------------------------------------
function modifier_ancient_dragon_small_reflect:IsHidden()
    return true
end

-----------------------------------------------------------------------------
function modifier_ancient_dragon_small_reflect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_REFLECT_SPELL,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

-----------------------------------------------------------------------------
function modifier_ancient_dragon_small_reflect:OnCreated(params)
    self:GetParent().tOldSpells = {}
end

-----------------------------------------------------------------------------
function modifier_ancient_dragon_small_reflect:GetAbsorbSpell(params)
    if not IsServer() then return end
    if self:GetParent():PassivesDisabled() then return end

    local spell = self:GetAbility()
    if spell:IsCooldownReady() then
        spell:StartCooldown(spell:GetCooldown(spell:GetLevel()))
        return 1
    end
    return false
end

-----------------------------------------------------------------------------
function modifier_ancient_dragon_small_reflect:GetReflectSpell(params)
    if not IsServer() then return end
	
	local caster = self:GetParent()
	if not caster or caster:IsNull() then return end

	local target = params.ability:GetCaster()
	if not target or target:IsNull() then return end
	
	if target:GetTeamNumber() == caster:GetTeamNumber() then return end
    if caster:PassivesDisabled() then return end
    if self:GetAbility():GetCooldownTimeRemaining() > 0 then return end

    local exception_spell =
    {
        ["rubick_spell_steal"] = true,
        ["obsidian_destroyer_astral_imprisonment"] = true,
        ["phantom_lancer_spirit_lance"] = true,
    }

	local spell = params.ability:GetAbilityName()
	if exception_spell[spell] then return end

    local part = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(part, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)


    if params.ability.spell_shield_reflect then
        return nil
    end
    local ability
    local old_spell = false

    for _, hSpell in pairs(caster.tOldSpells) do
        if hSpell ~= nil and hSpell:GetAbilityName() == spell then
            old_spell = true
            break
        end
    end

    if old_spell then
        caster:FindAbilityByName(spell)
    else
        ability = caster:AddAbility(spell)
        ability:SetStolen(true)
        ability:SetHidden(true)
        ability.spell_shield_reflect = true
        ability:SetRefCountsModifiers(true)
    end
    ability:SetLevel(params.ability:GetLevel())
    caster:SetCursorCastTarget(target)
    ability:OnSpellStart()

    return false
end

-----------------------------------------------------------------------------

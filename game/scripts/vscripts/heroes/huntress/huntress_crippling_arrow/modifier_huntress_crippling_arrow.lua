modifier_huntress_crippling_arrow = modifier_huntress_crippling_arrow or class({})

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:OnCreated(kv)
    self.duration_slow = self:GetAbility():GetSpecialValueFor("duration_slow")
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:OnRefresh(kv)
    self.duration_slow = self:GetAbility():GetSpecialValueFor("duration_slow")
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, }
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow:OnAttackLanded(params)
    if not IsServer() then return end
    local caster = self:GetParent()
    if params.attacker ~= caster or caster:PassivesDisabled() then return end
	
    local ability = self:GetAbility()
	if not ability:IsCooldownReady() then return end
	
    params.target:AddNewModifier(caster, ability, "modifier_huntress_crippling_arrow_slow", { duration = self.duration_slow })
    local rollChance = ability:GetSpecialValueFor("chance_root") + caster:GetTalentSpecialValueFor("huntress_crippling_arrow_chance_tallent")

    if params.target ~= nil and RollPercentage(rollChance) then
        local duration = ability:GetSpecialValueFor("duration_root") + caster:GetTalentSpecialValueFor("huntress_crippling_arrow_duration_tallent")

        if caster:HasModifier("modifier_huntress_hunting_spirit") and caster:HasTalent("huntress_hunting_spirit_heavy_arrow_tallent") then
            duration = duration / 100 * caster:GetTalentSpecialValueFor("huntress_hunting_spirit_heavy_arrow_tallent")
        end

        if caster:HasTalent("huntress_hunting_spirit_heavy_arrow_tallent") then
            if caster:HasModifier("modifier_huntress_hunting_spirit") then
                params.target:AddNewModifier(caster, ability, "modifier_huntress_crippling_arrow_stun", { duration = duration })
            else
                params.target:AddNewModifier(caster, ability, "modifier_huntress_crippling_arrow_root", { duration = duration })
            end
        else
            params.target:AddNewModifier(caster, ability, "modifier_huntress_crippling_arrow_root", { duration = duration })
        end
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1))
    end
end

--------------------------------------------------------------------------------

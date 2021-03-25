modifier_item_vampire_claw = modifier_item_vampire_claw or class({})
local mod = modifier_item_vampire_claw

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsHidden()         return true  end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end


function mod:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.bonusStr     = ability:GetSpecialValueFor("bonus_str")
    self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
    self.lifesteal    = ability:GetSpecialValueFor("lifesteal")
end

mod.OnRefresh = mod.OnCreated


--------------------------------------------------------------------------------
function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function mod:GetModifierPreAttack_BonusDamage(kv) return self.bonus_damage or 0 end
function mod:GetModifierBonusStats_Strength() return self.bonusStr or 0 end

function mod:OnAttackLanded(kv)
    if not self or self:IsNull() then return end

    local ability = self:GetAbility()

    if not ability or ability:IsNull() then return end

    if kv.attacker ~= self:GetCaster() then return end

    local target = kv.target

    if not target or target:IsNull() then return end

    if not target.IsBuilding then return end

    if target:IsBuilding() then return end

    local maxCharges = ability:GetSpecialValueFor("max_charges")
    local currentCharges = ability:GetCurrentCharges()
    local additionalCharges = 0


    if target:IsHero() then
        additionalCharges = ability:GetSpecialValueFor("charges_for_attack_hero")
    elseif target:IsCreep() then
        additionalCharges = ability:GetSpecialValueFor("charges_for_attack_creep")
    end

    local newChargesCount = currentCharges + additionalCharges

    if newChargesCount > maxCharges then newChargesCount = maxCharges end

    ability:SetCurrentCharges(newChargesCount)

    local damage = kv.damage
    local ursaSwipesModifierName = "modifier_ursa_fury_swipes_damage_increase"
    if kv.attacker:GetName() == "npc_dota_hero_ursa" and target:HasModifier(ursaSwipesModifierName)then
        local swapsAbility = kv.attacker:GetAbilityByIndex(2)
        local damagePerSwap = swapsAbility:GetSpecialValueFor("damage_per_stack")
        local stacks = target:GetModifierStackCount(ursaSwipesModifierName, kv.attacker)
        local bonusDamagePerSwaps = stacks*damagePerSwap
        damage = damage + bonusDamagePerSwaps
    end

    local armor_effictivity = 1
    local armor_value = target:GetPhysicalArmorValue( false )
    local armor = ( (0.06 * armor_value ) / ( 1+ 0.06 * math.abs(armor_value) ) )
    armor = armor * armor_effictivity
    if armor < 0 then armor = 0 end
    local steal = (damage - damage*armor) * (self.lifesteal/100)
    kv.attacker:Heal(steal, self)

    local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, kv.attacker)
    ParticleManager:SetParticleControl(particle, 0, kv.attacker:GetAbsOrigin())
    SendOverheadEventMessage(kv.attacker, OVERHEAD_ALERT_HEAL, kv.attacker, steal, nil)
end

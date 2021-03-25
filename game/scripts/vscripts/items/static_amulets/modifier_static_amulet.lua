static_mod_class = class({})

local items_names           = {["item_static_amulet"] = 1, ["item_slice_amulet"] = 1}
local amplify_name_mod      = "modifier_static_mag_amplify"
local count_name_mod        = "modifier_static_mag_amplify_count"
local ability_not_trigger = 
{
    ["invoker_invoke"] = 1,
    ["reaver_lord_attract"] = 1,
    ["phantom_lancer_phantom_edge"] = 1,
    ["leshrac_pulse_nova"] = 1,
}

--------------------------------------------------------------------------------

function static_mod_class:IsHidden()          return true end
function static_mod_class:IsPurgable()        return false end
function static_mod_class:DestroyOnExpire()   return false end
function static_mod_class:IsDebuff()          return false end
function static_mod_class:RemoveOnDeath()     return false end

function static_mod_class:GetAttributes()     return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
function static_mod_class:OnCreated(kv)
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
    self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")

    self.amplify_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
end
-----------------------------------------------------------------------------

function static_mod_class:DeclareFunctions() return 
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

--------------------------------------------------------------------------------

function static_mod_class:GetModifierPhysicalArmorBonus(kv) return self.bonus_armor; end

function static_mod_class:GetModifierBonusStats_Strength(kv) return self.bonus_stats; end

function static_mod_class:GetModifierBonusStats_Agility(kv) return self.bonus_stats; end

function static_mod_class:GetModifierBonusStats_Intellect(kv) return self.bonus_stats + self.bonus_int; end

--------------------------------------------------------------------------------

function static_mod_class:OnAbilityExecuted(keys)
    if not IsServer() then return end
    
    local caster = keys.unit

    if caster ~= self:GetParent() then return end 

    local ability        = self:GetAbility()
    local casted_ability = keys.ability

    if casted_ability:IsItem() then return end 

    for i = 0, 5 do
        local item = caster:GetItemInSlot(i)

        if item == ability then break end 
        
        if item and items_names[item:GetName()] and item ~= ability then
            return 
        end 
    end

    if casted_ability and ability_not_trigger[casted_ability:GetName()] then
        return
    end

    if casted_ability:GetCooldown(ability:GetLevel() - 1) == 0 then return end

    -- Stack counts 
    local hMod = caster:AddNewModifier(caster, ability, count_name_mod, { duration = self.amplify_duration } )
    hMod:IncrementStackCount()

    -- Real amplify 
    caster:AddNewModifier(caster, ability, amplify_name_mod, { duration = self.amplify_duration } )
end

modifier_static_amulet = class(static_mod_class)
modifier_slice_amulet = class(static_mod_class)
modifier_item_magician_ring = class({})

--------------------------------------------------------------------------------

function modifier_item_magician_ring:IsHidden()
    return true
end


--------------------------------------------------------------------------------
function modifier_item_magician_ring:IsAura()
    return true
end

--------------------------------------------------------------------------------
function modifier_item_magician_ring:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring:OnCreated(kv)
    local ability = self:GetAbility()

    ability._stacks = ability._stacks or 0

    self.max_stacks = ability:GetSpecialValueFor("max_stacks") or 0
    self.radius = ability:GetSpecialValueFor("aura_radius")
    self.stack_per_kill = ability:GetSpecialValueFor("stack_per_kill")
    self.stack_per_assist = ability:GetSpecialValueFor("stack_per_assist") or 0

    if IsServer() then
        local caster = self:GetParent()

        self:UpdateModifier(caster, ability, true)

        if ability._timer ~= nil then return end 

        ability._timer = true

        Timers:CreateTimer(0.01, function() 
                if ability:IsNull() then 
                    ability._timer = nil
                    return 
                end

                if caster:IsNull() then 
                    ability._timer = nil
                    return 
                end

                local item_name = ability:GetName()

                if (not caster:IsAlive() and not caster:IsReincarnating()) or (not caster:HasItemInInventory(item_name)) then 
                    ability._stacks = 0
                    ability._timer = nil
                    return 
                end

                return 0.01
            end)
    end
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring:OnDestroy(kv)
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        self:UpdateModifier(caster, ability, false)
    end
end


--------------------------------------------------------------------------------

function modifier_item_magician_ring:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_EVENT_ON_DEATH,
    }

    return funcs
end

--------------------------------------------------------------------------------
function modifier_item_magician_ring:GetModifierConstantHealthRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_hp_regen") or 0
end

--------------------------------------------------------------------------------
function modifier_item_magician_ring:GetModifierConstantManaRegen(params)
    return self:GetAbility():GetSpecialValueFor("bonus_manaregen") or 0
end

--------------------------------------------------------------------------------
function modifier_item_magician_ring:GetModifierPhysicalArmorBonus(params)
    return self:GetAbility():GetSpecialValueFor("bonus_armor") or 0
end

--------------------------------------------------------------------------------
function modifier_item_magician_ring:GetModifierCastRangeBonus(params)
    return self:GetAbility():GetSpecialValueFor("bonus_cast_range") or 0
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring:UpdateModifier(caster, ability, canAddNew)
    caster:RemoveModifierByName("modifier_item_magician_ring_buff")

    if ability._stacks ~= 0 and canAddNew then
        caster:AddNewModifier(caster, ability, "modifier_item_magician_ring_buff", {}) 
        caster:SetModifierStackCount("modifier_item_magician_ring_buff", caster, ability._stacks)
    end
end 

--------------------------------------------------------------------------------    

function modifier_item_magician_ring:OnDeath( keys )
    if IsServer() then
        local dead_hero = keys.unit 

        if not dead_hero:IsRealHero() then return end 

        local killer = keys.attacker 
        local caster = self:GetCaster()
        local ability = self:GetAbility()

        if not caster or not killer then return end
        
        if not ability then return end
        if ability:IsNull() then return end

        local bonus_stack = 0

        if dead_hero:GetTeamNumber() == caster:GetTeamNumber() then 
        	if caster == dead_hero then
        	    ability._stacks = 0
        	end

        	return 
        end

        if killer == caster or caster:GetOwner() == killer:GetOwner() then
            bonus_stack = self.stack_per_kill
        else 
            if (caster:GetAbsOrigin() - dead_hero:GetAbsOrigin()):Length() > self.radius then
                return
            end

            bonus_stack = self.stack_per_assist
        end

        ability._stacks = ability._stacks + bonus_stack

        if ability._stacks > self.max_stacks then
           ability._stacks = self.max_stacks
        end

        self:UpdateModifier(caster, ability, true)
    end
end

--------------------------------------------------------------------------------

huntress_owl = huntress_owl or class({})
LinkLuaModifier("huntress_owl_modifier_current_value", "heroes/huntress/huntress_owl/huntress_owl_modifier_current_value", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_huntress_owl_unit_vision", "heroes/huntress/huntress_owl/huntress_owl_unit/huntress_owl_unit_vision/modifier_huntress_owl_unit_vision", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huntress_owl_unit_vision_effect", "heroes/huntress/huntress_owl/huntress_owl_unit/huntress_owl_unit_vision/modifier_huntress_owl_unit_vision_effect", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_huntress_owl_aura_true_strike", "heroes/huntress/huntress_owl/huntress_owl_unit/huntress_owl_aura_true_strike/modifier_huntress_owl_aura_true_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huntress_owl_aura_true_strike_effect_lua", "heroes/huntress/huntress_owl/huntress_owl_unit/huntress_owl_aura_true_strike/modifier_huntress_owl_aura_true_strike_effect_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function huntress_owl:CreateOwl()
    local position = self:GetCursorTarget():GetOrigin() + Vector(0, 0, 180)
    local owl = CreateUnitByName("npc_aa_huntess_owl_unit", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
    owl:SetBaseMaxHealth(self:GetSpecialValueFor("health"))

    if self.current_owl_value < self.max_owl then
        self.table_owls[self.current_owl_value] = owl
    else
        self.table_owls[self.current_owl_value - 1] = owl
    end

    Timers:CreateTimer(0.1, function()
        owl:MoveToPosition(position)
        owl:AddNewModifier(self:GetCaster(), self, "modifier_huntress_owl_unit_vision", { duration = -1 })
        owl:AddNewModifier(self:GetCaster(), self, "modifier_huntress_owl_aura_true_strike", { duration = -1 })
        return nil
    end)

    if self:GetCaster():HasTalent("huntress_huntress_owl_invisible_tallent") then
        owl:AddNewModifier(self:GetCaster(), self, "modifier_invisible", { duration = -1 })
        return
    end
end

function huntress_owl:RewriteTableOwl(owl)
    local start
    for i = 0, self.max_owl do
        if self.table_owls[i] == owl then
            start = i
        end
    end
    for i = start, self.max_owl do
        self.table_owls[i] = self.table_owls[i + 1]
    end
end



function huntress_owl:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    self.max_owl = self:GetSpecialValueFor("max_owl")
    self.current_owl_value = caster:GetModifierStackCount("huntress_owl_modifier_current_value", caster)
    self.table_owls = self.table_owls or {}

    if self.current_owl_value < self.max_owl then
        self:CreateOwl()
        caster:AddNewModifier(caster, self, "huntress_owl_modifier_current_value", { duration = -1 })
        caster:SetModifierStackCount("huntress_owl_modifier_current_value", caster, self.current_owl_value + 1)
    else
        self.table_owls[0]:Kill(nil, caster)
        self:RewriteTableOwl(self.table_owls[0])
        self:CreateOwl()
    end

    caster:EmitSound("Hero_Huntress.Owl.Cast")
end

--------------------------------------------------------------------------------
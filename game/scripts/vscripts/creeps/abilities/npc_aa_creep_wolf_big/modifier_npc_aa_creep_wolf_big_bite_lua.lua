modifier_npc_aa_creep_wolf_big_bite_lua = class({})
-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_bite_lua:IsDebuff()
    return true
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_bite_lua:OnCreated( kv )
    self.slow_pct = self:GetAbility():GetSpecialValueFor( "slow_pct" )
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_bite_lua:OnRefresh( kv )
    self.slow_pct = self:GetAbility():GetSpecialValueFor( "slow_pct" )
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_bite_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------

function modifier_npc_aa_creep_wolf_big_bite_lua:GetModifierMoveSpeedBonus_Percentage ( params )
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return -self.slow_pct
end

-------------------------------------------------------------------------------

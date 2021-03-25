creep_bear_small_rage_lua = class({})
LinkLuaModifier( "modifier_creep_bear_small_rage_lua", "creeps/abilities/npc_aa_creep_bear_small/modifier_creep_bear_small_rage_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_bear_small_rage_lua:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_creep_bear_small_rage_lua", { duration = self:GetSpecialValueFor( "rage_duration" ) }  )
end

--------------------------------------------------------------------------------
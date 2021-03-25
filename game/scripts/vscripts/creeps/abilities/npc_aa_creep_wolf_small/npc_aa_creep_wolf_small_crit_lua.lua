npc_aa_creep_wolf_small_crit_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_wolf_small_crit_lua", "creeps/abilities/npc_aa_creep_wolf_small/modifier_npc_aa_creep_wolf_small_crit_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_wolf_small_crit_lua:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )
        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_wolf_small_crit_lua", { duration = self.duration } )
end

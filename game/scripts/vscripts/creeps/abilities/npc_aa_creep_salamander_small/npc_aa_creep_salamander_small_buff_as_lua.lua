npc_aa_creep_salamander_small_buff_as_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_salamander_small_buff_as_lua", "creeps/abilities/npc_aa_creep_salamander_small/modifier_npc_aa_creep_salamander_small_buff_as_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_salamander_small_buff_as_lua:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )

        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_salamander_small_buff_as_lua", { duration = self.duration } )

end

npc_aa_creep_wolf_big_buff_damage_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_wolf_big_buff_damage_lua", "creeps/abilities/npc_aa_creep_wolf_big/modifier_npc_aa_creep_wolf_big_buff_damage_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_wolf_big_buff_damage_lua:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )

        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_wolf_big_buff_damage_lua", { duration = self.duration } )

end

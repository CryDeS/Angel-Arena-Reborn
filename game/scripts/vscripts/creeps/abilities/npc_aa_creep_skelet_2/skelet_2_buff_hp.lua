skelet_2_buff_hp = class({})
LinkLuaModifier("modifier_skelet_2_buff_hp", "creeps/abilities/npc_aa_creep_skelet_2/modifier_skelet_2_buff_hp", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function skelet_2_buff_hp:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )
        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_skelet_2_buff_hp", { duration = self.duration } )
end

--------------------------------------------------------------------------------

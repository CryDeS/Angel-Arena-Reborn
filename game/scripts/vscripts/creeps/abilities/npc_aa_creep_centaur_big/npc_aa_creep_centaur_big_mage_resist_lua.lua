npc_aa_creep_centaur_big_mage_resist_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_centaur_big_mage_resist_lua", "creeps/abilities/npc_aa_creep_centaur_big/modifier_npc_aa_creep_centaur_big_mage_resist_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_centaur_big_mage_resist_lua:OnSpellStart()
    self.duration = self:GetSpecialValueFor( "duration" )
    self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_centaur_big_mage_resist_lua", { duration = self.duration } )
end

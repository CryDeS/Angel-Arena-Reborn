harpy_big_curse = class({})
LinkLuaModifier("modifier_harpy_big_curse", "creeps/abilities/npc_aa_creep_harpy_big/modifier_harpy_big_curse", LUA_MODIFIER_MOTION_NONE )

function harpy_big_curse:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )
        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_harpy_big_curse", { duration = self.duration } )
end

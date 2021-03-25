windwing_big_cyclone_lua = class({})
LinkLuaModifier("modifier_windwing_big_cyclone_lua", "creeps/abilities/npc_aa_creep_windwing_big/modifier_windwing_big_cyclone_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_windwing_big_cyclone_dawn_lua", "creeps/abilities/npc_aa_creep_windwing_big/modifier_windwing_big_cyclone_dawn_lua", LUA_MODIFIER_MOTION_NONE )


function windwing_big_cyclone_lua:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )
        self.target = self:GetCursorTarget()
        if self.target ~= nil and ( not self.target:IsInvulnerable() ) and ( not self.target:TriggerSpellAbsorb( self ) ) then
                self.target:AddNewModifier( self:GetCaster(), self, "modifier_windwing_big_cyclone_lua", { duration = self.duration} )
        end
end
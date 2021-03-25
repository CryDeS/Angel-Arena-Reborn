megacreep_mage_sleep_lua = class({})
LinkLuaModifier("modifier_megacreep_mage_sleep_lua", "creeps/abilities/npc_aa_megacreep_mage/modifier_megacreep_mage_sleep_lua", LUA_MODIFIER_MOTION_NONE )

function megacreep_mage_sleep_lua:OnSpellStart()
        self.duration = self:GetSpecialValueFor( "duration" )

        self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_megacreep_mage_sleep_lua", { duration = self.duration } )

end

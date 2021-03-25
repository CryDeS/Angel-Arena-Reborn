npc_aa_creep_salamander_small_buff_armor_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_salamander_small_buff_armor_lua", "creeps/abilities/npc_aa_creep_salamander_small/modifier_npc_aa_creep_salamander_small_buff_armor_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_salamander_small_buff_armor_lua:OnSpellStart()
        local radius = self:GetSpecialValueFor( "radius" )
        local duration = self:GetSpecialValueFor( "duration" )
        local caster = self:GetCaster()
        local alliance = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        local particle = ParticleManager:CreateParticle( "particles/wave_armor/wave_armor.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetCursorPosition() )

        if #alliance > 0 then
            for _,alli in pairs(alliance) do
                if alli ~= nil then
                    alli:AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_salamander_small_buff_armor_lua", { duration = duration } )
                end
            end
        end

end

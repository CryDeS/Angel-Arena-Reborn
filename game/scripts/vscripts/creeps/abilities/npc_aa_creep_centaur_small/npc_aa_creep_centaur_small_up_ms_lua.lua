npc_aa_creep_centaur_small_up_ms_lua = class({})
LinkLuaModifier( "modifier_npc_aa_creep_centaur_small_up_ms_lua", "creeps/abilities/npc_aa_creep_centaur_small/modifier_npc_aa_creep_centaur_small_up_ms_lua", LUA_MODIFIER_MOTION_NONE )

function npc_aa_creep_centaur_small_up_ms_lua:OnSpellStart()
        local radius = self:GetSpecialValueFor( "radius" )
        local duration = self:GetSpecialValueFor( "duration" )
        local alliance = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        local particle = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_dust.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetOrigin() )

        if #alliance > 0 then
            for _, alli in pairs(alliance) do
                if alli ~= nil then
                    alli:AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_centaur_small_up_ms_lua", { duration = duration } )
                end
            end
        end

end

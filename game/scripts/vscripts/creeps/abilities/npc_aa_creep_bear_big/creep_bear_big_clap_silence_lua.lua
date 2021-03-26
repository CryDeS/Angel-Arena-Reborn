creep_bear_big_clap_silence_lua = class({})

function creep_bear_big_clap_silence_lua:OnSpellStart()
        local radius = self:GetSpecialValueFor( "radius" )
        local duration = self:GetSpecialValueFor( "duration" )
        local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_shock.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetOrigin() )

        if #enemies > 0 then
            for _,enemy in pairs(enemies) do
                if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
                    enemy:AddNewModifier( self:GetCaster(), self, "modifier_silence", { duration = duration } )
                end
            end
        end

end

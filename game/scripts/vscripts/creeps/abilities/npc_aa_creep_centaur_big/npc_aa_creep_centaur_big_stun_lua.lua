npc_aa_creep_centaur_big_stun_lua = class({})

function npc_aa_creep_centaur_big_stun_lua:OnSpellStart()
    local radius = self:GetSpecialValueFor( "radius" )
    local duration = self:GetSpecialValueFor( "duration" )
    local damage = self:GetSpecialValueFor( "damage" )
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetOrigin() )

    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
                enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
                local info = {
                    victim = enemy,
                    attacker = self:GetCaster(),
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                }
                ApplyDamage( info )
            end
        end
    end
end
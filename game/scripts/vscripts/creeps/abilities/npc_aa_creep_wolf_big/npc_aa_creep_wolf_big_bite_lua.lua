npc_aa_creep_wolf_big_bite_lua = class({})
LinkLuaModifier("modifier_npc_aa_creep_wolf_big_bite_lua", "creeps/abilities/npc_aa_creep_wolf_big/modifier_npc_aa_creep_wolf_big_bite_lua", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------
function npc_aa_creep_wolf_big_bite_lua:OnSpellStart()
        self.damage = self:GetSpecialValueFor( "damage" )
        self.duration = self:GetSpecialValueFor( "duration" )
        local target = self:GetCursorTarget()

        target:AddNewModifier( self:GetCaster(), self, "modifier_npc_aa_creep_wolf_big_bite_lua", { duration = self.duration } )


        local info = {
                victim = target,
                attacker = self:GetCaster(),
                damage = self.damage,
                damage_type = DAMAGE_TYPE_PHYSICAL,
        }
        Timers:CreateTimer(0.4,
                function()
                        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ursa/ursa_claw_left.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
                        local particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_ursa/ursa_claw_right.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
                        ApplyDamage( info )
                        ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_ABSORIGIN_FOLLOW   , "attach_hitloc", target:GetAbsOrigin(), true)
                        ParticleManager:SetParticleControlEnt( particle2, 0, target, PATTACH_ABSORIGIN_FOLLOW   , "attach_hitloc", target:GetAbsOrigin(), true)
                end
        )
end

----------------------------------------------------------------------------

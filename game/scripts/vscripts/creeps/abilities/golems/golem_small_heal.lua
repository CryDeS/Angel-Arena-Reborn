golem_small_heal = golem_small_heal or class({})

function golem_small_heal:OnSpellStart()
	local caster = self:GetCaster() 
    local target = self:GetCursorTarget() 

    target:Heal( self:GetSpecialValueFor("health"), self)
    target:GiveMana( self:GetSpecialValueFor("mana") )

    local pidx = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( pidx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin() , true)
	ParticleManager:ReleaseParticleIndex( pidx )

	pidx = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( pidx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() , true)
	ParticleManager:SetParticleControlEnt( pidx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin() , true)
	ParticleManager:ReleaseParticleIndex( pidx )

	pidx = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( pidx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() , true)
	ParticleManager:ReleaseParticleIndex( pidx )

	target:EmitSound("Hero_Omniknight.Purification")
end

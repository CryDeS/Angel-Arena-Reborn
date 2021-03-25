--local particle = "particles/units/heroes/hero_wisp/wisp_ambient_b_stunned.vpcf"
local particle = "particles/new_charone/charone_spepcter.vpcf"
function HideUnit( event )
	event.caster:AddNoDraw()
	event.caster:Purge(false, true, false, true, false )
	event.caster:RemoveModifierByName("modifier_wisp_tether")
	event.caster.pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( event.caster.pfx, 0, event.caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( event.caster.pfx, 2, event.caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( event.caster.pfx, 3, event.caster:GetAbsOrigin() )
	ProjectileManager:ProjectileDodge(event.caster)
end

function ShowUnit( event )
	event.caster:RemoveNoDraw()
	ParticleManager:DestroyParticle( event.caster.pfx, false )
	event.caster.pfx = nil
end
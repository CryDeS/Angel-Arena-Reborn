modifier_hola_grace = class({})

function modifier_hola_grace:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_hola_grace:IsHidden( ... )
	return true
end


function modifier_hola_grace:OnCreated(kv)
	if not IsServer() then return end
	
	local ability 	= self:GetAbility()
	local parent 	= self:GetParent()
	local caster	= self:GetCaster()
	
	local heal_amount 	= kv.heal

	parent:Heal(heal_amount, caster)
	parent:EmitSound("Hero_Omniknight.Purification")
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, parent, heal_amount, nil)

	local part = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl( part, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( part, 1, Vector( 300, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( part )

end
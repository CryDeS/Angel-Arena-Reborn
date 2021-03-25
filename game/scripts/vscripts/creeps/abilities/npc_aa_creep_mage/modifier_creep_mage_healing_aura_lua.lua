modifier_creep_mage_healing_aura_lua = class({})

--------------------------------------------------------------------------------

function modifier_creep_mage_healing_aura_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creep_mage_healing_aura_lua:OnCreated( kv )
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

-------------------------------------------------------------------------------

function modifier_creep_mage_healing_aura_lua:OnRefresh( kv )
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

end

-------------------------------------------------------------------------------

function modifier_creep_mage_healing_aura_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

-------------------------------------------------------------------------------

function modifier_creep_mage_healing_aura_lua:OnAttacked(params)
	if self:GetParent():PassivesDisabled() then return end
	if not IsServer() then return end

	local team = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
--	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_shock.vpcf", PATTACH_CUSTOMORIGIN, caster )
--	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )

	if params.target == self:GetParent() and ( not self:GetParent():IsIllusion() )  then
	if #team > 0 then
			for _, ally in pairs(team) do
				if ally ~= nil then
					ally:Heal( self.heal, self )
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
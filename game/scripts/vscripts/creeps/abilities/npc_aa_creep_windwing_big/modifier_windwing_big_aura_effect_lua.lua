modifier_windwing_big_aura_effect_lua = modifier_windwing_big_aura_effect_lua or class({})

local mod = modifier_windwing_big_aura_effect_lua

function mod:IsHidden() return false end

function mod:IsDebuff() return false end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.lifesteal = ability:GetSpecialValueFor( "lifesteal" ) / 100
end

mod.OnRefresh = mod.OnCreated

if IsServer() then
	function mod:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	end

	function mod:OnAttackLanded( params )
		if not self or self:IsNull() then return end

		local parent = self:GetParent()

		if parent ~= params.attacker then return end

		if not parent or parent:IsNull() then return end

		local steal =  params.damage * (self.lifesteal or 0)

		local attacker = params.attacker

		parent:Heal(steal, self)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, parent )
		
		ParticleManager:SetParticleControl( particle, 0, parent:GetAbsOrigin() )

		SendOverheadEventMessage( parent, OVERHEAD_ALERT_HEAL, parent, steal, nil )
	end
end
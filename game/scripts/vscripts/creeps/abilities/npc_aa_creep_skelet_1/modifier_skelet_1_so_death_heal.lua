modifier_skelet_1_so_death_heal = modifier_skelet_1_so_death_heal or class({})

local mod = modifier_skelet_1_so_death_heal

function mod:IsHidden() return true end
function mod:IsDebuff() return false end
function mod:IsPurgable() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.pct_health_per_heal = ability:GetSpecialValueFor("pct_health_per_heal")
	self.cooldown            = ability:GetSpecialValueFor("cooldown")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end

function mod:OnTakeDamage(params)
	if not IsServer() then return end
	
	local parent = self:GetParent()

	if params.unit ~= parent then return end

	if parent:PassivesDisabled() then return end

	local ability = self:GetAbility()

	if ability:GetCooldownTimeRemaining() > 0 then return end

	local currentHp 	= parent:GetHealth()
	local maxHp 		= parent:GetMaxHealth()
	local needHpForHeal = maxHp / 100 * self.pct_health_per_heal

	if currentHp <= needHpForHeal then
		parent:Heal(maxHp, ability)
		ability:StartCooldown(self.cooldown)

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 3, parent:GetOrigin() )
	end
end

-------------------------------------------------------------------------------

soul_guardian_pure_heal = class({})
--------------------------------------------------------------------------------
function soul_guardian_pure_heal:OnSpellStart()
	local base_heal = self:GetSpecialValueFor("base_heal")
	local heal_pct_from_max_hp = self:GetSpecialValueFor("heal_pct_from_max_hp") / 100
	local caster = self:GetCaster()
	
	local healFromHP = caster:GetMaxHealth() * heal_pct_from_max_hp
	local heal = base_heal + healFromHP
	local healParticle = ParticleManager:CreateParticle(
		"particles/bosses/soul_guardian/soul_guardian_pure_heal/soul_guardian_pure_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(healParticle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	caster:Heal(heal, self)
	caster:Purge(false, true, false, true, false)
end

--------------------------------------------------------------------------------

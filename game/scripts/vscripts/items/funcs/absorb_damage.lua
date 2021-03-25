function AbsorbDamage(event)
	local caster  = event.caster
	local ability = event.ability
	local damage  = event.damage or 0

	if not ability or not caster then return end
	if caster:IsIllusion() then return end
	if caster:HasModifier("modifier_arc_warden_tempest_double") then return end
	if damage >= caster:GetHealth() then return end

	caster:Heal(damage, ability)
end
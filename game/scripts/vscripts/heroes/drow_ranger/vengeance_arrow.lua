function VengeanceArmorSuccess(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.attacker
	local heal = event.Damage or 0
	local cooldown = ability:GetCooldown( ability:GetLevel() -1)
	if not caster or not ability or not target then end
	if caster:IsIllusion() then return end
	
	if caster:PassivesDisabled() then return end
	if caster:IsHexed() then return end 
	
	if heal < 10 then return end
	if ability:GetCooldownTimeRemaining() > 0 then return end

	if heal > caster:GetHealth() then
		heal = caster:GetHealth() 
	end
	
	caster:Heal(heal, ability)

	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > 2000 then return end
	
	if not caster:IsInvisible() and not caster:IsHexed() then
		caster:PerformAttack(target, false, false, true, false, true, false, false) 
	end

	ability:StartCooldown(cooldown)
end
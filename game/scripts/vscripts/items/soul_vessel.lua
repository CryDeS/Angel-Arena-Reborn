function OnKill( keys )
	if keys.unit and keys.unit:IsRealHero() then
		keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()  + keys.ChargePerKill)
	end
end

function OnSpellStart( keys )
	local caster 	= keys.caster
	local target 	= keys.target
	local ability 	= keys.ability 
	local modifier_name = ""
	
	if not target then return end

	if caster:GetTeamNumber() == target:GetTeamNumber() then
		modifier_name = keys.FriendModifier
		target:Heal(target:GetMaxHealth() * keys.FriendHealPct / 100 + keys.FriendHealConst, ability)
		target:GiveMana(target:GetMaxMana() * keys.FriendHealPct / 200 + keys.FriendHealConst / 2)
	else
		modifier_name = keys.EnemyModifier
		ApplyDamage({	victim = target,
						attacker = caster,
						damage = target:GetHealth() * keys.EnemyDamagePct / 100 + keys.EnemyDamageConst,
						damage_type = DAMAGE_TYPE_MAGICAL,	}) 
	end

	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {}) 
end
function Damage(event)
	local target = event.target
	local caster = event.caster
	local damage_pct = event.dmg_pct / 100
	local damage_const = event.dmg_const or 0

	if not target or not caster then return end

	local damage_total = caster:GetIntellect()*damage_pct + damage_const
	ApplyDamage({ victim = target, attacker = caster, damage = damage_total, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability }) 

	if caster:HasTalent("special_bonus_unique_queen_of_pain_2") then
		target:AddNewModifier(caster, event.ability, "modifier_queenofpain_scream_of_pain_fear", { duration = caster:GetTalentSpecialValueFor( "special_bonus_unique_queen_of_pain_2" )})
	end 
end

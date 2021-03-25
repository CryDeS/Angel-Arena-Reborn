--DEAL PURE DAMAGE THAT DEPENDS OF CURRENT HEALTH
function DamageCurrentHP(event) -- deal damage to current health (pct) + const damage and heal caster
	local target = event.target
	local damage_pct = event.dmg_pct / 100
	local caster = event.caster
	local damage_const = event.dmg_const or 0

	if not target or not damage_pct or not caster then return end


	local damage_total = (target:GetMaxHealth()*damage_pct) + damage_const

	if BossSpawner:IsBoss(target) then
		damage_total = damage_total / 8
	end

	if caster:HasTalent("special_bonus_unique_bane_2") then
		damage_total = caster:GetTalentSpecialValueFor("special_bonus_unique_bane_2")
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage_total,	damage_type = DAMAGE_TYPE_PURE }) 
	caster:Heal(damage_total, ability)
end


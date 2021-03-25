local talent_name = "spike_special_bonus_attack"

function OnKill( keys )
	local modifier_name = "modifier_spike_special_bonus_attack"
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.unit 
	local damage_by_hero = ability:GetSpecialValueFor("damage_by_hero")
	local damage_by_creep = ability:GetSpecialValueFor("damage_by_creep")


	if not caster:HasAbility(talent_name) then return end

	if caster:FindAbilityByName(talent_name):GetLevel() == 0 then return end

	if(not caster:HasModifier(modifier_name) ) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_name, {}) 
	end

	local stack_count = caster:GetModifierStackCount(modifier_name, caster) or 0

	if( target:IsRealHero() or BossSpawner:IsBoss(target) ) then
		stack_count = stack_count + damage_by_hero
	else
		ability.killed_creeps = (ability.killed_creeps or 0) + 1 
		if(ability.killed_creeps >= 1 ) then
			stack_count = stack_count + damage_by_creep
			ability.killed_creeps = 0
		end
	end

	caster:SetModifierStackCount(modifier_name, caster, stack_count)
end
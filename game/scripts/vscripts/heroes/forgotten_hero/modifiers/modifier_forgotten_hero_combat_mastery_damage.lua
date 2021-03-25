modifier_forgotten_hero_combat_mastery_damage = modifier_forgotten_hero_combat_mastery_damage or class({})
local mod = modifier_forgotten_hero_combat_mastery_damage

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return false end
function mod:DestroyOnExpire()  return true  end
function mod:IsPurgeException() return false  end

function mod:OnCreated()
	local ability = self:GetAbility()

	if not ability then return end

	self.damage = ability:GetSpecialValueFor("bonus_damage_per_hero")
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function mod:GetModifierPreAttack_BonusDamage(kv)
    return self.damage * self:GetStackCount()
end

function mod:GetEffectName()
	return "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon_gold/wd_ti10_immortal_ambient_gold_haze.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

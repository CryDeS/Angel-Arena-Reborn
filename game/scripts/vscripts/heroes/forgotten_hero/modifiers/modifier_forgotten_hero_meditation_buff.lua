modifier_forgotten_hero_meditation_buff = modifier_forgotten_hero_meditation_buff or class({})
local mod = modifier_forgotten_hero_meditation_buff

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return true end
function mod:IsPurgeException() return true  end
function mod:DestroyOnExpire()  return true  end

function mod:OnCreated( kv )
	local parent  = self:GetParent()
	
	if not parent then return end

	self.damage = parent:GetTalentSpecialValueFor("forgotten_hero_talent_meditation_damage_buff", "damage")
end

function mod:OnDestroy()
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
} 
end

function mod:GetModifierPreAttack_BonusDamage(kv)
    return self.damage
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

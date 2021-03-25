modifier_forgotten_hero_breach = modifier_forgotten_hero_breach or class({})
local mod = modifier_forgotten_hero_breach

function mod:IsHidden() 	 	return false end
function mod:RemoveOnDeath() 	return true  end
function mod:IsDebuff() 	 	return false end
function mod:IsPurgable() 	 	return false end
function mod:IsPurgeException() return false  end
function mod:DestroyOnExpire()  return true  end

function mod:OnCreated( kv )
	local parent  = self:GetParent()
	local ability = self:GetAbility()
	
	if not parent or not ability then return end

	self.ms = ability:GetSpecialValueFor("bonus_ms")

	if not IsServer() then return end
	
	self.crit = parent:GetTalentSpecialValueFor("forgotten_hero_talent_breach_crits")


	self._parent = parent
end

function mod:OnDestroy()
	if not IsServer() then return end

	local parent = self._parent

	if parent and not parent:IsNull() then
		parent:EmitSound("Hero_ForgottenHero.Breach.End")
	end
end

function mod:CheckState() return 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_INVISIBLE] = true,
}
end

function mod:DeclareFunctions()
	local res = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}

	if self.crit ~= 0 then
		table.insert(res, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE)
	end

	return res
end

function mod:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end

	self:Destroy()
end

function mod:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if not self then return end

	local target = params.target

	if not target or target:IsNull() or not target:IsAlive() then return end

	self:Destroy()
end

function mod:GetModifierInvisibilityLevel()
	return 1000
end

function mod:GetModifierPreAttack_CriticalStrike()
	return self.crit
end

function mod:GetModifierMoveSpeedBonus_Percentage()
	return self.ms
end

function mod:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function mod:GetEffectName()
	return "particles/heroes/forgotten_hero/breach/breach.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

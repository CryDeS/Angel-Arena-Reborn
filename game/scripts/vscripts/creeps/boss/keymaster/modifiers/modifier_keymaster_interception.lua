modifier_keymaster_interception = modifier_keymaster_interception or class({})
mod = modifier_keymaster_interception

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true  end
function mod:IsAura() 			return true  end

function mod:OnCreated( kv )
	local ability = self:GetAbility()
	local caster  = self:GetParent()

	if not ability or ability:IsNull() or not caster or caster:IsNull() then return end

	if IsServer() then
		self.radius = ability:GetCastRange(caster:GetAbsOrigin(), nil) + caster:GetCastRangeBonus()
	end

	self.hpRegen 	= ability:GetSpecialValueFor("hp_regen_pct")
	self.hpRegenDec = ability:GetSpecialValueFor("hp_regen_decrease")
end

mod.OnRefresh = mod.OnCreated

function mod:OnDestroy( kv )
	if not self or self:IsNull() then return end
	if not IsServer() then return end

	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end

	parent:EmitSound("Boss_Keymaster.Interception.End")
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
}
end

function mod:GetEffectName()
	return "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
end

function mod:GetModifierHealthRegenPercentage()
	if not self or self:IsNull() then return 0 end
	if not self.GetStackCount then return 0 end

	local stackCount = self:GetStackCount()
	local hpReg 	 = self.hpRegen - self.hpRegenDec * stackCount

	return max(hpReg, 0)
end

function mod:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function mod:GetModifierAura()
	return "modifier_keymaster_interception_effect"
end

function mod:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function mod:GetAuraDuration()
	return 0
end

function mod:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function mod:GetAuraRadius()
	if not self or self:IsNull() then return 0 end

	return self.radius
end


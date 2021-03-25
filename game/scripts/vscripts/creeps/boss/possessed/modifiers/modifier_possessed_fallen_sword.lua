modifier_possessed_fallen_sword = modifier_possessed_fallen_sword or class({})
local mod = modifier_possessed_fallen_sword

function mod:IsDebuff() 		return false end
function mod:IsHidden() 		return true end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return false end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end
	if not IsServer() then return end

	self.damage 		= ability:GetSpecialValueFor("damage")
	self.chance 		= ability:GetSpecialValueFor("chance")
	self.killThresshold = ability:GetSpecialValueFor("kill_thresshold")
	self.cleaveRadius 	= ability:GetSpecialValueFor("cleave_radius")
	self.cleaveVal 		= ability:GetSpecialValueFor("cleave") / 100
	self.debuffDuration = ability:GetSpecialValueFor("debuff_duration")
	self.damageType 	= ability:GetAbilityDamageType()

	self.stream = self.stream or CreateUniformRandomStream( GameRules:GetGameTime() )
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function mod:GetModifierTotalDamageOutgoing_Percentage()
	return self.damageModifier or 0
end

function mod:OnAttackStart( params )
	if not IsServer() then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = params.target

	if not ability or parent ~= params.attacker then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	local stream = self.stream

	if not stream then return end

	if stream:RollPercentage( self.chance ) then
		self.mod = parent:AddNewModifier(parent, ability, "modifier_possessed_fallen_sword_anim", { duration = -1 })
	end
end

function mod:OnAttackLanded( params )
	if not IsServer() then return end

	if not self then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = params.target

	if not ability or parent ~= params.attacker then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	local mod = self.mod
	local damageType = self.damageType

	if mod then
		self.mod = nil

		if not mod:IsNull() then
			mod:Destroy()
		end

		ApplyDamage({
			victim 		= target,
			attacker 	= parent,
			damage 		= self.damage,
			damage_type = damageType,
			ability 	= ability,
		})
		
		target:EmitSound("Boss_Possessed.FallenSword.DebuffHit")

		if target:GetHealthPercent() < self.killThresshold then
			target:Kill(ability, parent)
			target:EmitSound("Boss_Possessed.FallenSword.Kill")
		else
			target:AddNewModifier(parent, ability, "modifier_possessed_fallen_sword_debuff", { duration = self.debuffDuration })
		end
	end

	local currentDamage = params.damage

	local cleaveVal = self.cleaveVal

	if not cleaveVal then return end

	local damage = cleaveVal * currentDamage

	local units = FindUnitsInRadius( parent:GetTeamNumber(),
									 target:GetAbsOrigin(),
									 target,
							 		 self.cleaveRadius,
							 		 ability:GetAbilityTargetTeam(),
							 		 ability:GetAbilityTargetType(),
							 		 ability:GetAbilityTargetFlags(),
							 		 FIND_ANY_ORDER, 
							 		 false )

	for _, unit in pairs(units) do
		if unit ~= target then
			ApplyDamage({
				victim 		= unit,
				attacker 	= parent,
				damage 		= damage,
				damage_type = damageType,
				ability 	= ability,
			})
		end
	end
end

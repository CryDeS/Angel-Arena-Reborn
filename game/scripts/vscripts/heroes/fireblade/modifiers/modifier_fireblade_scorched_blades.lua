modifier_fireblade_scorched_blades = modifier_fireblade_scorched_blades or class({})
local mod = modifier_fireblade_scorched_blades

local itemModNames = {
	"modifier_passive_burning_blades_damn_passive",
	"modifier_burning_book",
	"modifier_curse_demons_fury",
}

function mod:IsHidden() 		return true end
function mod:IsDebuff() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return false  end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function mod:OnCreated( kv )
	if not IsServer() then return end

	local ability = self:GetAbility()

	if not ability then return end

	self.damage  = ability:GetSpecialValueFor("damage")
	self.itemDmg = ability:GetSpecialValueFor("damage_with_item_pct") / 100
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function mod:OnAttackLanded( kv )
	if not IsServer() then return end 

	local parent = self:GetParent()

	if not parent then return end

	if parent:PassivesDisabled() then return end

	if parent ~= kv.attacker then return end

	local ability = self:GetAbility()

	local target = kv.target

	if not target:IsAlive() then return end
	if target:IsMagicImmune() and not parent:HasTalent("fireblade_talent_scorched_blades_spellimmune") then return end

	local damage = self.damage

	for _, modName in pairs(itemModNames) do
		if parent:HasModifier(itemModName) then
			damage = damage + parent:GetAverageTrueAttackDamage(nil) * self.itemDmg
			break
		end
	end

	ApplyDamage({
		victim 		= target,
		attacker 	= parent,
		damage 		= damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability 	= ability,
	})

	local dur = parent:GetTalentSpecialValueFor("fireblade_talent_scorched_blades_silence")

	if dur > 0 and ability:GetCooldownTimeRemaining() == 0 then
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1) * parent:GetCooldownReduction())
		target:AddNewModifier(parent, ability, "modifier_fireblade_scorched_blades_debuff", { duration = dur })
	end
end
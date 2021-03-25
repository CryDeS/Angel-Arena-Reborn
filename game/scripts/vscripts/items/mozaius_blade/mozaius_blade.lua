require('items/second_attacks')

item_mozaius_blade = item_mozaius_blade or class({})
local ability = item_mozaius_blade

LinkLuaModifier("modifier_mozaius_blade", 	 	"items/mozaius_blade/modifiers/modifier_mozaius_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mozaius_blade_cd", 	"items/mozaius_blade/modifiers/modifier_mozaius_blade_cd", LUA_MODIFIER_MOTION_NONE)

MeleeSecondAttack:RegisterSecondAttack("modifier_mozaius_blade_cd")

function ability:GetIntrinsicModifierName()
	return "modifier_mozaius_blade"
end

function ability:OnSpellStart()
	local charges = self:GetCurrentCharges()

	if charges <= 0 then return end

	local heal = charges * self:GetSpecialValueFor("heal_per_charge")

	local caster = self:GetCaster()

	self:SetCurrentCharges(0)
	
	caster:Heal(heal, self)

	SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal, nil)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	caster:EmitSound("Item_MozaiusBlade.Cast")
end
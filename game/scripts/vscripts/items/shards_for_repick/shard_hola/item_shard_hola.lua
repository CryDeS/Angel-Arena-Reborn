item_shard_hola = item_shard_hola or class({})
item_shard_hola_dummy = item_shard_hola

local ability = item_shard_hola

LinkLuaModifier("modifier_item_shard_hola", 'items/shards_for_repick/shard_hola/modifier_item_shard_hola', LUA_MODIFIER_MOTION_NONE)

ability.ForceShareable = true

function ability:GetIntrinsicModifierName()
	return "modifier_item_shard_hola"
end

function ability:OnSpellStart()
	local heal = self:GetSpecialValueFor("heal_const")
	local target = self:GetCursorTarget()
	local particleHeal = ParticleManager:CreateParticle("particles/item_shard_hola/item_shard_hola.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particleHeal, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	target:Heal(heal, self)
	target:Purge(false, true, false, true, false )
end
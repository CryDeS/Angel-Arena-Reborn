item_shard_satan = item_shard_satan or class({})
item_shard_satan_dummy = item_shard_satan

LinkLuaModifier("modifier_item_shard_satan", 'items/shards_for_repick/shard_satan/modifier_item_shard_satan', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shard_satan_active", 'items/shards_for_repick/shard_satan/modifier_item_shard_satan_active', LUA_MODIFIER_MOTION_NONE)

item_shard_satan.ForceShareable = true

--------------------------------------------------------------------------------
function item_shard_satan:GetIntrinsicModifierName()
	return "modifier_item_shard_satan"
end

-----------------------------------------------------------------------------
function item_shard_satan:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	local particleShardSatan = ParticleManager:CreateParticle("particles/item_shard_satan/item_shard_satan.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particleShardSatan, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_shard_satan_active", { duration = duration })
			end
		end
	end
end

keymaster_damned_souls = keymaster_damned_souls or class({})
local ability = keymaster_damned_souls

LinkLuaModifier( "modifier_keymaster_damned_souls", 		'creeps/boss/keymaster/modifiers/modifier_keymaster_damned_souls', 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_keymaster_damned_souls_debuff", 	'creeps/boss/keymaster/modifiers/modifier_keymaster_damned_souls_debuff', 	LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end

	if not self or self:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end

	self.mod = caster:AddNewModifier(caster, self, "modifier_keymaster_damned_souls", { duration = -1 })

	caster:EmitSound("Boss_Keymaster.DamnedSouls.Cast")

	ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end

function ability:OnProjectileHit(hTarget)
	if not IsServer() then return end
	if not self or self:IsNull() then return end

	if hTarget then
		hTarget:TriggerSpellReflect(self)

		if hTarget:TriggerSpellAbsorb(self) then return end

		if hTarget:IsNull() then return end
	end

	if self.mod then
		self.mod:OnHit(hTarget)
	end
end
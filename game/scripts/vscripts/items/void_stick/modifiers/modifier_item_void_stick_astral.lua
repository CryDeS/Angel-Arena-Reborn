modifier_item_void_stick_astral = class({})
--------------------------------------------------------------------------------

function modifier_item_void_stick_astral:IsHidden() return false end
function modifier_item_void_stick_astral:IsPurgable() return false end
function modifier_item_void_stick_astral:DestroyOnExpire() return true end
function modifier_item_void_stick_astral:IsDebuff() return false end
function modifier_item_void_stick_astral:GetTexture() return "../items/void_stick_big" end

function modifier_item_void_stick_astral:OnCreated( kv )
	self.regen = self:GetAbility():GetSpecialValueFor("astral_regen")
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local casterPosition = self:GetAbility():GetCaster():GetAbsOrigin()
		caster:AddNoDraw()
		self.particle1 = ParticleManager:CreateParticle("particles/void_stick/void_stick_astral.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(self.particle1, 0, casterPosition+Vector(0,0,135))
		caster:Purge(false, true, false, true, false )
		caster:RemoveModifierByName("modifier_wisp_tether")

	end
end

function modifier_item_void_stick_astral:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle1,false)
		self:GetAbility():GetCaster():RemoveNoDraw()
	end
end

--------------------------------------------------------------------------------

function modifier_item_void_stick_astral:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
}
end


function modifier_item_void_stick_astral:CheckState() return
{
	[MODIFIER_STATE_OUT_OF_GAME] 	= true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE] 	= true,
	[MODIFIER_STATE_MAGIC_IMMUNE] 	= true,
	[MODIFIER_STATE_NO_HEALTH_BAR] 	= true,
	[MODIFIER_STATE_INVULNERABLE] 	= true,
	[MODIFIER_STATE_INVISIBLE] 		= true,
}
end

--------------------------------------------------------------------------------

function modifier_item_void_stick_astral:GetModifierHealthRegenPercentage( params ) return self.regen end
function modifier_item_void_stick_astral:GetModifierTotalPercentageManaRegen( params ) return self.regen end
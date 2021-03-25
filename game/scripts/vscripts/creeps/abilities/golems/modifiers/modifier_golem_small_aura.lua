modifier_golem_small_aura = class({})

--------------------------------------------------------------------------------

function modifier_golem_small_aura:IsHidden() 			return false 	end
function modifier_golem_small_aura:IsDebuff() 			return false 	end
function modifier_golem_small_aura:IsPurgable() 		return false 	end
function modifier_golem_small_aura:DestroyOnExpire() 	return true 	end

------------------------------------------------------------------------------

function modifier_golem_small_aura:DeclareFunctions() return 
{ 
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, 
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end

--------------------------------------------------------------------------------

function modifier_golem_small_aura:GetModifierConstantHealthRegen() return self.hp_regen end
function modifier_golem_small_aura:GetModifierConstantManaRegen() 	return self.mp_regen end


function modifier_golem_small_aura:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.hp_regen = ability:GetSpecialValueFor("hp_regen")
	self.mp_regen = ability:GetSpecialValueFor("mana_regen")
end

modifier_golem_small_aura.OnRefresh = modifier_golem_small_aura.OnCreated
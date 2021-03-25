modifier_ancient_dragon_big_ancient_form = class({})
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:OnCreated()
	if not IsServer() then return end
	self.model_scale = self:GetParent():GetModelScale()
	self:GetParent():SetModelScale(self.model_scale * 1.2)
	self.new_max_hp = self:GetAbility():GetSpecialValueFor( "add_hp" )
	self.add_damage = self:GetAbility():GetSpecialValueFor( "add_damage" )
end
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:GetModifierBaseAttack_BonusDamage()
	return self.add_damage
end
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:GetModifierHealthBonus()
	return self.new_max_hp
end
---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:OnDestroy()
	if not IsServer() then return end
	self:GetParent():SetModelScale(self.model_scale)
end
---------------------------------------------------------------------------

function modifier_ancient_dragon_big_ancient_form:GetEffectName()
--	return "particles/econ/items/bane/slumbering_terror/slumbering_terror_nightmare_ringdriver.vpcf"
    return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

---------------------------------------------------------------------------
function modifier_ancient_dragon_big_ancient_form:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------
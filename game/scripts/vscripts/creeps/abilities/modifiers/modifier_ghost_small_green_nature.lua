modifier_ghost_small_green_nature = class({})

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:OnCreated(kv)
	self.attackspeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end 

--------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_leech_seed_projectile_leaves_sprite.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_ghost_small_green_nature:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------------------------

function modifier_ghost_small_green_nature:GetModifierPhysicalArmorBonus()
	return self.armor
end 

function modifier_ghost_small_green_nature:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end 

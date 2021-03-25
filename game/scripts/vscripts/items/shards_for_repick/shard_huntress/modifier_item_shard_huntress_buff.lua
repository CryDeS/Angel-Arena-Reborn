modifier_item_shard_huntress_buff = class({})
--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:DestroyOnExpire()
    return true
end
--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:GetStatusEffectName(kv)
	return "particles/item_shard_huntress/item_shard_huntress.vpcf"
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:GetTexture()
	return "../items/shard_huntress_big"
end
--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:OnCreated(kv)
    self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
    self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed")
end

--------------------------------------------------------------------------------
function modifier_item_shard_huntress_buff:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_item_shard_huntress_buff:GetModifierMoveSpeedBonus_Percentage(kv) return self.movespeed; end
function modifier_item_shard_huntress_buff:GetModifierAttackSpeedBonus_Constant(kv) return self.attackspeed; end

--------------------------------------------------------------------------------

modifier_ghost_small_blue_magic_curse = class({})

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:OnCreated(kv)
	self.resist = kv.resist
end 

--------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff_c.vpcf"
end

---------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------------------------------------

function modifier_ghost_small_blue_magic_curse:GetModifierMagicalResistanceBonus()
	return self.resist
end 
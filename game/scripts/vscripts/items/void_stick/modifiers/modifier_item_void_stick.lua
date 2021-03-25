modifier_item_void_stick = class({})
--------------------------------------------------------------------------------

function modifier_item_void_stick:IsHidden() return true end
function modifier_item_void_stick:IsPurgable() return false end
function modifier_item_void_stick:DestroyOnExpire() return false end
function modifier_item_void_stick:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT end

--------------------------------------------------------------------------------

function modifier_item_void_stick:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_CAST_RANGE_BONUS,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

--------------------------------------------------------------------------------
function modifier_item_void_stick:ReloadCooldownBuff()
	if not IsServer() then return end
	local parent = self:GetParent()
	local cooldownModifierName = "modifier_item_void_stick_cooldown"
	local hasMainBuff = parent:HasModifier(self:GetName())

	if not parent:HasModifier(cooldownModifierName) and hasMainBuff then
		parent:AddNewModifier(parent, self:GetAbility(), cooldownModifierName, nil)
	elseif not hasMainBuff then
		parent:RemoveModifierByName(cooldownModifierName)
	end
end

--------------------------------------------------------------------------------

function modifier_item_void_stick:OnCreated()
	local ability = self:GetAbility()
	self.bonus_int 					= ability:GetSpecialValueFor("bonus_int") or 0
	self.bonus_hp 					= ability:GetSpecialValueFor("bonus_hp") or 0
	self.bonus_mana 				= ability:GetSpecialValueFor("bonus_mana") or 0
	self.bonus_mgregen 				= ability:GetSpecialValueFor("bonus_mpregen") or 0
	self.bonus_hpregen 				= ability:GetSpecialValueFor("bonus_hpregen") or 0
	self.bonus_castrange 			= ability:GetSpecialValueFor("bonus_castrange") or 0
	self.bonus_speed 				= ability:GetSpecialValueFor("bonus_speed") or 0

	self:ReloadCooldownBuff()
end

--------------------------------------------------------------------------------

function modifier_item_void_stick:GetModifierManaBonus( params ) return self.bonus_mana end
function modifier_item_void_stick:GetModifierHealthBonus( params ) return self.bonus_hp end
function modifier_item_void_stick:GetModifierBonusStats_Intellect( params ) return self.bonus_int end

function modifier_item_void_stick:GetModifierConstantManaRegen( params ) return self.bonus_mgregen end
function modifier_item_void_stick:GetModifierConstantHealthRegen( params ) return self.bonus_hpregen end
function modifier_item_void_stick:GetModifierCastRangeBonus( params ) return self.bonus_castrange end

function modifier_item_void_stick:GetModifierMoveSpeedBonus_Constant( params ) return self.bonus_speed end

function modifier_item_void_stick:OnDestroy( params )
	self:ReloadCooldownBuff()
end
--------------------------------------------------------------------------------


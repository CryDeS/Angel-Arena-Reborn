modifier_item_void_stick_cooldown = class({})
--------------------------------------------------------------------------------

function modifier_item_void_stick_cooldown:IsHidden() return true end
function modifier_item_void_stick_cooldown:IsPurgable() return false end
function modifier_item_void_stick_cooldown:DestroyOnExpire() return false end
function modifier_item_void_stick_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT end

--------------------------------------------------------------------------------

function modifier_item_void_stick_cooldown:DeclareFunctions() return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end
--------------------------------------------------------------------------------

function modifier_item_void_stick_cooldown:OnCreated(kv)
	self.bonus_cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction") or 0
end
--------------------------------------------------------------------------------
function modifier_item_void_stick_cooldown:GetModifierPercentageCooldown( params ) return self.bonus_cooldown_reduction end

